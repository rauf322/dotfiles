require("workspace-diagnostics").setup()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("workspace_diagnostics", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      if client:supports_method("workspace/diagnostic", ev.buf) then
        vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
      else
        require("workspace-diagnostics").populate_workspace_diagnostics(client, ev.buf)
      end
    end
  end,
})
