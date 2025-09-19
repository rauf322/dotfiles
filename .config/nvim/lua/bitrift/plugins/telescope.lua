return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master", -- Use latest version instead of old tag
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local action = require("telescope.actions")
			local builtin = require("telescope.builtin")

			-- Configure file and directory exclusions
			telescope.load_extension("fzf")
			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"%.git/", -- Ignore .git directory
						"%.git\\", -- Windows support
						"node_modules/", -- Ignore node_modules directory
						"node_modules\\", -- Windows support
						"dist/", -- Common build directory
						"build/", -- Common build directory
						"%.o", -- Object files
						"%.a", -- Static libraries
						"%.out", -- Output files
						"%.class", -- Java class files
						"%.pdf", -- PDF files
						"%.zip", -- Archive files
						"%.iso", -- ISO files
						"%.tar", -- Archive files
						"%.gz", -- Compressed files
						"%.rar", -- Compressed files
						"%.7z", -- Compressed files
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden", -- Search hidden files
						"--glob=!.git/", -- Exclude .git directory
						"--glob=!node_modules/", -- Exclude node_modules directory
					},
				},
				pickers = {
					find_files = {
						hidden = true, -- This will include hidden files like .config
					},
					git_files = {
						hidden = true, -- Also include hidden files in git_files
						show_untracked = true,
					},
				},
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			telescope.load_extension("ui-select")
			telescope.load_extension("noice")
			local keymap = vim.keymap.set
			keymap("n", "<leader>?", ":Telescope keymaps<CR>", { desc = "Telescope: Show Keymaps" })
			keymap("n", "<C-p>", builtin.git_files, { desc = "Telescope: Git Files" })
			keymap("n", "<leader>pws", function()
				builtin.grep_string({ search = vim.fn.expand("<cword>") })
			end, { desc = "Telescope: Grep Current Word" })
			keymap("n", "<leader>pWs", function()
				builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
			end, { desc = "Telescope: Grep Current WORD" })
			-- keymap("n", "<leader>ps", function()
			-- 	require("telescope.builtin").live_grep()
			-- end, { desc = "Telescope: Live Grep" })
			keymap("n", "<leader>vh", builtin.help_tags, { desc = "Telescope: Help Tags" })
			keymap("n", "<leader>gt", ":Telescope git_branches <CR>", { desc = "Telescope: Git branches" })

			-- Plugin reload picker
			keymap("n", "<leader>pr", function()
				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local conf = require("telescope.config").values
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				local plugin_commands = {
					{ display = "🔧 Reload nvim-autopairs", command = "RestartAutopairs" },
					{
						display = "🌳 Reload Treesitter highlighting",
						command = "TSBufDisable highlight | TSBufEnable highlight",
					},
					{ display = "📡 Restart LSP clients", command = "LspRestart" },
					{ display = "🔄 Update Treesitter parsers", command = "TSUpdate" },
					{
						display = "⚡ Force reload all LSP",
						command = "lua vim.lsp.stop_client(vim.lsp.get_active_clients()); vim.cmd('edit')",
					},
					{ display = "🎨 Reload lualine statusline", command = "lua require('lualine').refresh()" },
					{
						display = "📢 Restart Noice UI",
						command = "lua require('noice').setup(); print('Noice reloaded!')",
					},
					{
						display = "🔧 Reload none-ls sources",
						command = "lua require('null-ls').setup(); print('none-ls reloaded!')",
					},
					{ display = "📁 Reload Mason registry", command = "MasonUpdate" },
					{
						display = "🧪 Refresh Neotest adapters",
						command = "lua require('neotest').setup_project(); print('Neotest refreshed!')",
					},
					{
						display = "🍪 Reload Snacks.nvim",
						command = "lua package.loaded['snacks'] = nil; require('snacks'); print('Snacks reloaded!')",
					},
					{
						display = "🎯 Reload current buffer LSP",
						command = "lua vim.lsp.buf_detach_client(0, vim.lsp.get_active_clients()[1].id); vim.cmd('edit')",
					},
					{ display = "🔄 Reload all plugins (dangerous)", command = "Lazy sync" },
				}

				pickers
					.new({}, {
						prompt_title = "🔄 Plugin Reload Manager",
						finder = finders.new_table({
							results = plugin_commands,
							entry_maker = function(entry)
								return {
									value = entry,
									display = entry.display,
									ordinal = entry.display,
								}
							end,
						}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, map)
							actions.select_default:replace(function()
								local selection = action_state.get_selected_entry()
								actions.close(prompt_bufnr)

								local command = selection.value.command
								local success = pcall(function()
									if command:match("^lua ") then
										local lua_code = command:gsub("^lua ", "")
										local func = load(lua_code)
										if func then
											func()
										end
									else
										vim.cmd(command)
									end
								end)

								if success then
									print(
										"✅ "
											.. selection.value.display:gsub("^[^%s]+ ", "")
											.. " executed successfully!"
									)
								else
									print("❌ Failed to execute: " .. selection.value.display:gsub("^[^%s]+ ", ""))
								end
							end)
							return true
						end,
					})
					:find()
			end, { desc = "Telescope: Plugin Reload Manager" })
		end,
	},
}
