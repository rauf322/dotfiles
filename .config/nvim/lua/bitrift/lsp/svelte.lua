return {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	capabilities = require("bitrift.lsp.capabilities"),
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.js", "*.ts" },
			callback = function(ctx)
				client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
	end,
}
