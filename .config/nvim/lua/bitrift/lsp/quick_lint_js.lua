return {
	cmd = { "quick-lint-js", "--lsp-server" },
	filetypes = { "javascript" },
	capabilities = require("bitrift.lsp.capabilities"),
}
