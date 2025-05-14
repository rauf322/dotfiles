return {
	"stevearc/conform.nvim",
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
}
