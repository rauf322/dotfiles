return {
	cmd = { "copilot-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"python",
		"lua",
		"go",
		"rust",
		"java",
		"c",
		"cpp",
		"css",
		"html",
		"json",
		"yaml",
		"markdown",
	},
	root_markers = { ".git" },
	capabilities = require("bitrift.lsp.capabilities"),
	settings = {
		telemetry = {
			telemetryLevel = "off",
		},
	},
}
