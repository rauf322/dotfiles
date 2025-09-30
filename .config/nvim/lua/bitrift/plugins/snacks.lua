return {
	"folke/snacks.nvim",
	priority = 1000, -- before other plugins that might rely on it
	lazy = false, -- load at startup (so terminal keys are ready)
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "OilActionsPost",
			callback = function(event)
				if event.data.actions.type == "move" then
					Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
				end
			end,
		})
	end,
	keys = {

		{
			"<leader>ps",
			function()
				Snacks.picker.grep()
			end,
			desc = "Search in files",
			mode = "n",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Buffer delete",
			mode = "n",
		},
		{
			"<leader>ba",
			function()
				Snacks.bufdelete.all()
			end,
			desc = "Buffer delete all",
			mode = "n",
		},
		{
			"<leader><Tab>",
			function()
				Snacks.picker.files({
					finder = "files",
					format = "file",
					show_empty = true,
					supports_live = true,
					-- In case you want to override the layout for this keymap
					-- layout = "vscode",
				})
			end,
			desc = "Find Files",
		},
		{
			"<leader>bo",
			function()
				Snacks.bufdelete.other()
			end,
			desc = "Buffer delete other",
			mode = "n",
		},
		{
			"<leader>bz",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
			mode = "n",
		},
	},
	opts = {
		picker = {
			debug = {
				scores = false, -- show scores in the list
			},
			formatters = {
				file = {
					filename_first = true, -- display filename before the file path
					truncate = 80,
				},
			},
			layout = {
				-- preset = "ivy",
				-- When reaching the bottom of the results in the picker, I don't want
				-- it to cycle and go back to the top
				cycle = false,
			},
			matcher = {
				frecency = true,
			},
			image = {
				enabled = true,
				doc = {
					-- Personally I set this to false, I don't want to render all the
					-- images in the file, only when I hover over them
					-- render the image inline in the buffer
					-- if your env doesn't support unicode placeholders, this will be disabled
					-- takes precedence over `opts.float` on supported terminals
					inline = vim.g.neovim_mode == "skitty" and true or false,
					-- only_render_image_at_cursor = vim.g.neovim_mode == "skitty" and false or true,
					-- render the image in a floating window
					-- only used if `opts.inline` is disabled
					float = true,
					-- Sets the size of the image
					-- max_width = 60,
					-- max_width = vim.g.neovim_mode == "skitty" and 20 or 60,
					-- max_height = vim.g.neovim_mode == "skitty" and 10 or 30,
					max_width = vim.g.neovim_mode == "skitty" and 5 or 60,
					max_height = vim.g.neovim_mode == "skitty" and 2.5 or 30,
					-- max_height = 30,
					-- Apparently, all the images that you preview in neovim are converted
					-- to .png and they're cached, original image remains the same, but
					-- the preview you see is a png converted version of that image
					--
					-- Where are the cached images stored?
					-- This path is found in the docs
					-- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
					-- For me returns `~/.cache/neobean/snacks/image`
					-- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
				},
			},
		},
		input = { enabled = true },
		indent = { enabled = true },
		dashboard = {
			preset = {
				pick = nil,
				---@type snacks.dashboard.Item[]
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = "󰒲 ",
						key = "l",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				header = [[
                                                                             
               ████ ██████           █████      ██                     
              ███████████             █████                             
              █████████ ███████████████████ ███   ███████████   
             █████████  ███    █████████████ █████ ██████████████   
            █████████ ██████████ █████████ █████ █████ ████ █████   
          ███████████ ███    ███ █████████ █████ █████ ████ █████  
         ██████  █████████████████████ ████ █████ █████ ████ ██████ 
      ]],
			},
			sections = {
				{ section = "header" },
				{
					section = "keys",
					indent = 1,
					padding = 1,
				},
				{ section = "recent_files", icon = " ", title = "Recent Files", indent = 3, padding = 2 },
				{ section = "startup" },
			},
		},
		terminal = {
			start_insert = false,
			auto_insert = false,
			auto_close = false,
			win = {
				style = "minimal",
				enter = true,
				keys = {
					term_normal = {
						"<esc>",
						function()
							return "<C-\\><C-n>"
						end,
						mode = "t",
						expr = true,
						desc = "Escape to normal mode",
					},
					term_close = {
						"<esc><esc>",
						function()
							vim.cmd("close")
						end,
						mode = "t",
						desc = "Double escape to close terminal",
					},
					q = "hide",
					["<esc>"] = "hide",
				},
			},
		},
	},

	config = function(_, opts)
		require("snacks").setup(opts)
		vim.keymap.set("n", "<leader>`", function()
			require("snacks.terminal").toggle()
		end, { desc = "Toggle terminal" })

		-- Terminal mode escape for snacks terminal
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit snacks terminal mode" })
		Snacks.toggle.new({
			id = "ufo",
			name = "Enable/Disable ufo",
			get = function()
				return require("ufo").inspect()
			end,
			set = function(state)
				if state == nil then
					require("noice").enable()
					require("ufo").enable()
					vim.o.foldenable = true
					vim.o.foldcolumn = "1"
				else
					require("noice").disable()
					require("ufo").disable()
					vim.o.foldenable = false
					vim.o.foldcolumn = "0"
				end
			end,
		})

		vim.o.ttimeoutlen = 0
	end,
}
