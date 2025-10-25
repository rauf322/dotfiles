return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	config = function()
		require("typescript-tools").setup({
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				local opts = { buffer = bufnr, silent = true }

				vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<CR>", { desc = "TS: Organize Imports" })
				vim.keymap.set("n", "<leader>ts", "<cmd>TSToolsSortImports<CR>", { desc = "TS: Sort Imports" })
				vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnused<CR>", { desc = "TS: Remove Unused" })
				vim.keymap.set(
					"n",
					"<leader>tm",
					"<cmd>TSToolsAddMissingImports<CR>",
					{ desc = "TS: Add Missing Imports" }
				)
				vim.keymap.set("n", "<leader>tf", "<cmd>TSToolsFixAll<CR>", { desc = "TS: Fix All" })
				vim.keymap.set(
					"n",
					"<leader>tg",
					"<cmd>TSToolsGoToSourceDefinition<CR>",
					{ desc = "TS: Go to Source Definition" }
				)
				vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRenameFile<CR>", { desc = "TS: Rename File" })
				vim.keymap.set(
					"n",
					"<leader>tR",
					"<cmd>TSToolsFileReferences<CR>",
					{ desc = "TS: File References" }
				)
			end,
			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				expose_as_code_action = {
					"fix_all",
					"add_missing_imports",
					"remove_unused",
					"remove_unused_imports",
					"organize_imports",
				},
				tsserver_path = nil,
				tsserver_plugins = {},
				tsserver_max_memory = "auto",
				tsserver_format_options = {},
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "literals",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = false,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = false,
					includeInlayFunctionLikeReturnTypeHints = false,
					includeInlayEnumMemberValueHints = false,
					includeCompletionsForModuleExports = true,
					includeCompletionsWithInsertText = true,
					quotePreference = "auto",
					includeCompletionsForImportStatements = true,
					includeCompletionsWithSnippetText = true,
					includeAutomaticOptionalChainCompletions = true,
				},
				tsserver_locale = "en",
				complete_function_calls = false,
				include_completions_with_insert_text = true,
				code_lens = "off",
				disable_member_code_lens = true,
				jsx_close_tag = {
					enable = true,
					filetypes = { "javascriptreact", "typescriptreact" },
				},
			},
		})
	end,
}