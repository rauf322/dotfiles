return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"ts_ls",
				"pyright",
				"jsonls",
				"dockerls",
				"sqls",
				"yamlls",
				"copilot",
				"eslint",
				"solidity_ls_nomicfoundation",
				"gopls",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"biome",
				"prettierd",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
				"js-debug-adapter",
				"htmlhint",
				"sql-formatter",
				"gofumpt",
				"goimports",
			},
		},
	},
}
