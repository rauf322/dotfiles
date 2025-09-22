return {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css" },
	capabilities = require("bitrift.lsp.capabilities"),
}
