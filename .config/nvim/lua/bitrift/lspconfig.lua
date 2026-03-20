local keymap = vim.keymap

-- Disabled inline completion (ghost text) - using nvim-cmp instead
-- vim.lsp.inline_completion.enable()

-- ESLint LSP: auto-fix on save via vim.lsp.config (0.11+)
vim.lsp.config("eslint", {
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
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
    severity = { min = severity.ERROR, max = severity.ERROR }, -- Only show ERROR level
  },
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
