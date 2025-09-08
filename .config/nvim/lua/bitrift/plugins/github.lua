return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Fugitive: Git Status" })

			local rauf322 = vim.api.nvim_create_augroup("rauf322", {})
			local autocmd = vim.api.nvim_create_autocmd

			autocmd("BufWinEnter", {
				group = rauf322,
				pattern = "*",
				callback = function()
					if vim.bo.ft ~= "fugitive" then
						return
					end

					local bufnr = vim.api.nvim_get_current_buf()
					local opts = { buffer = bufnr, remap = false }

					vim.keymap.set("n", "<leader>p", function()
						vim.cmd.Git("push")
					end, vim.tbl_extend("force", opts, { desc = "Fugitive: Git Push" }))

					vim.keymap.set("n", "<leader>P", function()
						vim.cmd("Git pull --rebase")
					end, vim.tbl_extend("force", opts, { desc = "Fugitive: Git Pull --rebase" }))

					vim.keymap.set(
						"n",
						"<leader>cm",
						":Git commit -m 'autocommit'<CR>",
						vim.tbl_extend("force", opts, { desc = "Fugitive: Auto Commit" })
					)

					vim.keymap.set(
						"n",
						"<leader>t",
						":Git push -u origin ",
						vim.tbl_extend("force", opts, { desc = "Fugitive: Git Push With Upstream" })
					)
				end,
			})

			vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "DiffGet: Accept Our (LOCAL) Change" })
			vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "DiffGet: Accept Their (REMOTE) Change" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",

		config = function()
			require("gitsigns")
			vim.keymap.set(
				"n",
				"<leader>gl",
				":Gitsigns toggle_current_line_blame<CR>",
				{ desc = "Gitsign current line blame" }
			)
			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Gitsign inspect preview" })
		end,
	},

	-- Modern GitHub Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>", -- Alt+Enter to open panel
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-y>", -- Ctrl+y to accept suggestion
						accept_word = "<C-w>", -- Alt+w to accept word
						dismiss = "<C-n>", -- Ctrl+] to dismiss
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 18.x
				server_opts_overrides = {},
			})

			-- Easy toggle functionality
			vim.keymap.set("n", "<leader>ct", function()
				local copilot = require("copilot.suggestion")
				if copilot.is_visible() then
					copilot.dismiss()
					vim.cmd("Copilot disable")
					vim.notify("Copilot disabled", vim.log.levels.INFO)
				else
					vim.cmd("Copilot enable")
					vim.notify("Copilot enabled", vim.log.levels.INFO)
				end
			end, { desc = "Toggle Copilot" })

			-- Additional helpful commands
			vim.keymap.set("n", "<leader>cs", "<cmd>Copilot status<CR>", { desc = "Copilot status" })
			vim.keymap.set("n", "<leader>cp", "<cmd>Copilot panel<CR>", { desc = "Copilot panel" })
		end,
	},

	-- Copilot integration with nvim-cmp
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
