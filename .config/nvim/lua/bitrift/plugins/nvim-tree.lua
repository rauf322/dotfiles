local clipboardHelper = require("bitrift.utils.clipboardHelper")
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")
		vim.opt.fillchars:append("vert: ") -- removes the vertical separator line

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			live_filter = {
				prefix = "[FILTER]: ", -- Prefix when filtering
				always_show_folders = false, -- 🔥 THIS hides folders that don’t match the filter
			},

			auto_reload_on_write = true,
			update_focused_file = {
				enable = true,
				update_root = true,
				ignore_list = {},
			},
			view = {
				width = 30,
				side = "right",
				adaptive_size = true, -- Allow dynamic resizing
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
			},
			actions = {
				open_file = {
					quit_on_open = true,
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store", ".git", "node_module" },
			},
			git = {
				ignore = false,
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				-- Load default keybindings
				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.set(
					"n",
					"C",
					clipboardHelper.copy_file_to_clipboard,
					{ buffer = bufnr, desc = "Copy file to system clipboard" }
				)

				-- Custom override for <CR>
				vim.keymap.set("n", "<CR>", function()
					local node = api.tree.get_node_under_cursor()
					if node.nodes ~= nil then
						api.node.open.edit()
					else
						local current_win = vim.api.nvim_get_current_win()
						local win_ids = vim.api.nvim_tabpage_list_wins(0)
						local target_win = current_win
						for _, win in ipairs(win_ids) do
							if
								vim.api.nvim_win_get_config(win).relative == ""
								and vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "NvimTree"
							then
								target_win = win
								break
							end
						end
						if target_win ~= current_win then
							vim.api.nvim_set_current_win(target_win)
						end
						api.node.open.edit()
					end
				end, { buffer = bufnr, noremap = true, silent = true })
			end,
		})

		-- Prevent BufEnter from triggering for nvim-tree buffers
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "NvimTree_*",
			callback = function()
				vim.b.no_lint = true
			end,
		})

		-- Set keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set(
			"n",
			"<leader>ff",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		)
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
		keymap.set("n", "<M-Tab>", "<C-^>", { desc = "Toggle last buffer" })
		keymap.set("n", "<leader>we", function()
			require("nvim-tree.view").resize("30")
			vim.cmd("wincmd =")
		end, { desc = "Equalize all windows" })
	end,
}
