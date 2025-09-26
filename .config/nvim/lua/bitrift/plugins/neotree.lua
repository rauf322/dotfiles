return {
	"nvim-neo-tree/neo-tree.nvim",
	event = "VeryLazy",
	branch = "v3.x",
	cmd = { "Neotree" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		-- Disable netrw (same as nvim-tree)
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			-- Window configuration matching nvim-tree
			window = {
				position = "right",
				width = 30,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					-- Disable built-in search
					["f"] = "noop",

					-- Custom clipboard copy (C key)
					["C"] = function(state)
						local node = state.tree:get_node()
						if not node then
							print("No item selected!")
							return
						end

						local path = vim.fn.expand(node.path)
						path = path:gsub('"', '\\"')

						local applescript_cmd =
							string.format('osascript -e "set the clipboard to POSIX file \\"%s\\""', path)
						local result = os.execute(applescript_cmd)

						if result == 0 then
							local item_type = node.type == "directory" and "folder" or "file"
							print("Copied " .. item_type .. " to system clipboard: " .. path)
						else
							print("Failed to copy to clipboard")
						end
					end,

					-- Delete to trash (D key)
					["D"] = function(state)
						local inputs = require("neo-tree.ui.inputs")
						local node = state.tree:get_node()
						if node.type == "message" then
							return
						end
						local msg = "Are you sure you want to delete " .. node.name .. " to trash?"
						inputs.confirm(msg, function(confirmed)
							if not confirmed then
								return
							end

							-- Use trash command on macOS
							local trash_cmd = "trash " .. vim.fn.shellescape(node.path)
							local result = vim.fn.system(trash_cmd)
							if vim.v.shell_error == 0 then
								print("Moved to trash: " .. node.name)
								require("neo-tree.sources.manager").refresh("filesystem")
							else
								print("Failed to move to trash: " .. result)
							end
						end)
					end,

					-- Normal delete (d key) - keep default behavior
					-- ["d"] uses neo-tree's default delete
					-- Keep default x (cut) and p (paste) operations

					-- Smart Enter key behavior (same as nvim-tree)
					["<CR>"] = function(state)
						local node = state.tree:get_node()
						if node.type == "directory" then
							if node:is_expanded() then
								require("neo-tree.sources.filesystem").toggle_directory(state, node)
							else
								require("neo-tree.sources.filesystem").toggle_directory(state, node)
							end
						else
							-- Open file logic - find non-neo-tree window
							local current_win = vim.api.nvim_get_current_win()
							local win_ids = vim.api.nvim_tabpage_list_wins(0)
							local target_win = current_win

							for _, win in ipairs(win_ids) do
								local buf = vim.api.nvim_win_get_buf(win)
								local filetype = vim.bo[buf].filetype
								if vim.api.nvim_win_get_config(win).relative == "" and filetype ~= "neo-tree" then
									target_win = win
									break
								end
							end

							if target_win ~= current_win then
								vim.api.nvim_set_current_win(target_win)
							end

							require("neo-tree.sources.filesystem.commands").open(state)
							-- Close neo-tree after opening file
							require("neo-tree.command").execute({ action = "close" })
						end
					end,
				},
			},

			filesystem = {
				-- Follow current file (same as nvim-tree update_focused_file)
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				-- Show hidden files by default (matches nvim-tree filters.dotfiles = true)
				filtered_items = {
					visible = false, -- Hidden by default
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_hidden = true,
				},
				-- Auto-refresh on write
				use_libuv_file_watcher = true,
			},

			-- Simple event handlers - let Neo-tree handle file operations natively
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						-- Close neo-tree when file is opened (quit_on_open behavior)
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})

		-- Global keymaps (same as nvim-tree)
		local keymap = vim.keymap
		keymap.set("n", "<leader>ef", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>ff", function()
			-- Smart behavior: close if in neo-tree, reveal if outside
			if vim.bo.filetype == "neo-tree" then
				vim.cmd("Neotree close")
			else
				vim.cmd("Neotree reveal")
			end
		end, { desc = "Toggle file explorer on current file" })
		keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Close file explorer" })
		keymap.set("n", "<leader>er", "<cmd>Neotree filesystem refresh<CR>", { desc = "Refresh file explorer" })
		keymap.set("n", "<M-Tab>", "<C-^>", { desc = "Toggle last buffer" })

		-- Window equalization (same as nvim-tree)
		keymap.set("n", "<leader>we", function()
			-- Find neo-tree window and resize
			local neo_tree_wins = vim.tbl_filter(function(win)
				local buf = vim.api.nvim_win_get_buf(win)
				return vim.bo[buf].filetype == "neo-tree"
			end, vim.api.nvim_tabpage_list_wins(0))

			if #neo_tree_wins > 0 then
				vim.api.nvim_win_set_width(neo_tree_wins[1], 30)
			end
			vim.cmd("wincmd =")
		end, { desc = "Equalize all windows" })
	end,
}
