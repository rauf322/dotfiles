local servers = {
  "html",
  "cssls",
  "tailwindcss",
  "svelte",
  "lua_ls",
  "graphql",
  "emmet_ls",
  "prismals",
  "tsc",
  "pyright",
  "jsonls",
  "dockerls",
  "sqls",
  "yamlls",
  "eslint",
  "oxlint",
  "solidity_ls_nomicfoundation",
  "hls",
  "gopls",
  "rust_analyzer",
  "clangd",
}

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  automatic_enable = false,
  ensure_installed = servers,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "biome",
    "prettierd",
    "stylua",
    "isort",
    "black",
    "js-debug-adapter",
    "htmlhint",
    "sql-formatter",
    "gofumpt",
    "goimports",
    "solhint",
  },
})

-- LSP server configs auto-discovered from ~/.config/nvim/lsp/*.lua
vim.lsp.enable(servers)

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
