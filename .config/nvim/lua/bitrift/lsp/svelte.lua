return {
  cmd = { "svelteserver", "--stdio" },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        client.rpc.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      end,
    })
  end,
}
