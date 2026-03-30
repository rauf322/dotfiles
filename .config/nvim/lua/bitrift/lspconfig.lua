-- Enable LSP servers (configs auto-discovered from ~/.config/nvim/lsp/*.lua)
vim.lsp.enable({
  "html",
  "cssls",
  "tailwindcss",
  "svelte",
  "lua_ls",
  "graphql",
  "emmet_ls",
  "prismals",
  "ts_ls",
  "pyright",
  "jsonls",
  "dockerls",
  "sqls",
  "yamlls",
  "eslint",
  "oxlint",
  "solidity_ls_nomicfoundation",
  "gopls",
  "rust_analyzer",
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
