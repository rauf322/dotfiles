return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
	capabilities = require("bitrift.lsp.capabilities"),
	on_attach = function(client, bufnr)
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
		quiet = false,
		run = "onType",
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "location",
		},
	},
}
