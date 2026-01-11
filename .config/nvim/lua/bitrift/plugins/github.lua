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
			require("gitsigns").setup({
				current_line_blame = true,
			})
			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Gitsigns preview hunk" })
			vim.keymap.set({ "n", "v" }, "<leader>ga", ":Gitsigns <Tab>", { desc = "Gitsigns actions" })
		end,
	},
}
