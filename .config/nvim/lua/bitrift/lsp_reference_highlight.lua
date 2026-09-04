-- Highlight other references of the symbol under the cursor after it rests
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentHighlightProvider then
        vim.lsp.buf.document_highlight()
        break
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
  group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = false }),
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})
