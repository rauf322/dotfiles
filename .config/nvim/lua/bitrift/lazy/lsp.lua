return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"j-hui/fidget.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"windwp/nvim-autopairs",
		"rafamadriz/friendly-snippets", -- Keep for blink.cmp snippets
	},
	config = function()
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("blink.cmp").get_lsp_capabilities()
		)

		require("fidget").setup({})
		require("render-markdown").setup({
			completions = { coq = { enabled = true } },
		})

		-- Mason setup
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Autopairs setup
		local npairs = require("nvim-autopairs")
		npairs.setup({
			check_ts = true,
			map_cr = true,
			map_complete = true,
		})

		-- LSP key mappings
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })

		-- Mason-lspconfig setup
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,

				["ts_ls"] = function()
					-- configure typescript language server
					local lspconfig = require("lspconfig")
					lspconfig["tsserver"].setup({
						capabilities = capabilities,
						filetypes = {
							"javascript",
							"javascriptreact",
							"javascript.jsx",
							"typescript",
							"typescriptreact",
							"typescript.tsx",
						},
						init_options = {
							preferences = {
								disableSuggestions = false,
							},
						},
						-- Optional: Add on_attach for additional setup if needed
						-- on_attach = function(client, bufnr)
						--     -- Custom setup for TypeScript files
						-- end,
					})
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
									},
								},
							},
						},
					})
				end,

				["svelte"] = function()
					-- configure svelte server
					local lspconfig = require("lspconfig")
					lspconfig["svelte"].setup({
						capabilities = capabilities,
						---@diagnostic disable-next-line: unused-local
						on_attach = function(client, bufnr)
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									-- Here use ctx.match instead of ctx.file
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,

				["graphql"] = function()
					-- configure graphql language server
					local lspconfig = require("lspconfig")
					lspconfig["graphql"].setup({
						capabilities = capabilities,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,

				["emmet_ls"] = function()
					-- configure emmet language server
					local lspconfig = require("lspconfig")
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,
			},
		})

		-- Mason-tool-installer setup
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
				"eslint_d",
				"js-debug-adapter",
				"htmlhint",
			},
		})

		-- Diagnostic configuration
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
				max_width = 80,
			},
		})
	end,
}
