return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters.eslint_d = vim.tbl_deep_extend("force", lint.linters.eslint_d or {}, {
				args = {
					"--format",
					"json",
					"--stdin",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
				},
			})
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				python = { "pylint" },
			}
			local grp = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = grp,
				callback = function()
					lint.try_lint()
				end,
			})
			vim.keymap.set("n", "<leader>tl", function()
				lint.try_lint()
			end, { desc = "Trigger linting" })
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					liquid = { "prettier" },
					lua = { "stylua" },
					python = { "isort", "black" },
				},
				format_on_save = { lsp_fallback = true, async = false, timeout_ms = 500 },
			})
			vim.keymap.set({ "n", "v" }, "<leader>s", function()
				conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
				vim.cmd("wa")
			end, { desc = "Format file(s) and save" })
		end,
	},
}
