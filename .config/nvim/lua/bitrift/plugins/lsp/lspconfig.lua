return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
		"antosha417/nvim-lsp-file-operations",
	},

	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = vim.tbl_deep_extend(
			"force",
			cmp_nvim_lsp.default_capabilities(),
			require("lsp-file-operations").default_capabilities()
		)

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings
				-- Check `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- keymaps
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Show definiton of word (type)"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
			end,
		})

		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}
		vim.diagnostic.config({
			signs = {
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = {
				severity = { min = vim.diagnostic.severity.ERROR },
				prefix = "✘",
			},
			underline = true, -- Specify Underline diagnostics
			update_in_insert = true, -- Keep diagnostics active in insert mode
		})

		-- Disable visual diagnostics in insert mode
		vim.api.nvim_create_autocmd("InsertEnter", {
			callback = function()
				vim.diagnostic.config({
					virtual_text = false,
					underline = false,
				})
			end,
		})

		-- Re-enable visual diagnostics when leaving insert mode
		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = function()
				vim.diagnostic.config({
					virtual_text = {
						severity = { min = vim.diagnostic.severity.ERROR },
						prefix = "✘",
					},
					underline = true,
				})
			end,
		})
		require("render-markdown").setup({
			completions = { coq = { enabled = true } },
		})
		
		-- CSS Language Server
		vim.lsp.config.cssls = {
			cmd = { "vscode-css-language-server", "--stdio" },
			capabilities = capabilities,
			filetypes = { "css" },
		}

		-- Lua Language Server
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		}

		-- Svelte Language Server
		vim.lsp.config.svelte = {
			cmd = { "svelteserver", "--stdio" },
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
		}

		-- GraphQL Language Server
		vim.lsp.config.graphql = {
			cmd = { "graphql-lsp", "server", "-m", "stream" },
			capabilities = capabilities,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		}

		-- Quick Lint JS
		vim.lsp.config.quick_lint_js = {
			cmd = { "quick-lint-js", "--lsp-server" },
			capabilities = capabilities,
			filetypes = { "javascript" },
		}

		-- ESLint Language Server
		vim.lsp.config.eslint = {
			cmd = { "vscode-eslint-language-server", "--stdio" },
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- Enable auto-fix on save
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.code_action({
							filter = function(action)
								return action.kind == "source.fixAll.eslint"
							end,
							apply = true,
						})
					end,
				})
			end,
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = true,
					},
				},
				codeActionOnSave = {
					enable = false,
					mode = "all",
				},
				format = true,
				nodePath = "",
				onIgnoredFiles = "off",
				packageManager = "npm",
				problems = {
					shortenToSingleLine = false,
				},
				quiet = false,
				rulesCustomizations = {},
				run = "onType",
				useESLintClass = false,
				validate = "on",
				workingDirectory = {
					mode = "location",
				},
			},
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"svelte",
			},
		}
	end,
}
