return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				python = { "pylint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>tl", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
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
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				},
				-- formatters = {
				-- 	prettier = {
				-- 		prepend_args = { "--single-quote", "--semi", "false", "--tab-width", "2" }, -- Align with ESLint rules
				-- 	},
				-- },
			})
			vim.keymap.set({ "n", "v" }, "<leader>s", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
				vim.cmd("wa") -- no <CR> needed
			end, { desc = "Format file and save it" })
		end,
	},
}
