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
  ensure_installed = {
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
    "copilot",
    "eslint",
    "oxlint",
    "solidity_ls_nomicfoundation",
    "gopls",
    "rust_analyzer",
  },
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
