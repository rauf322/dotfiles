return {
	cmd = { "graphql-lsp", "server", "-m", "stream" },
	filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
	capabilities = require("bitrift.lsp.capabilities"),
}
