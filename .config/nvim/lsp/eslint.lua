return {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if vim.fn.exists(":EslintFixAll") > 0 then
          vim.cmd("EslintFixAll")
        end
      end,
    })
  end,
}
