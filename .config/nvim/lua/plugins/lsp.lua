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

-- The `tsc` server is tsgo, a Go binary whose only memory knob is GOMEMLIMIT. Its npm shim
-- exec's the binary with an empty environment (Node 24 process.execve without env), so the
-- variable only arrives when the native binary is spawned directly.
local tsgo_mem_limit = "12GiB"

local function tsgo_native_binary(root)
  local uname = vim.uv.os_uname()
  local arch = ({ x86_64 = "x64", aarch64 = "arm64" })[uname.machine] or uname.machine
  local pkg = "@typescript/typescript-" .. uname.sysname:lower() .. "-" .. arch .. "/lib/tsc"
  local candidates = {
    root .. "/node_modules/" .. pkg,
    root .. "/node_modules/typescript/node_modules/" .. pkg,
  }
  local shim = vim.uv.fs_realpath(vim.fn.exepath("tsc"))
  if shim then
    local typescript_dir = vim.fs.dirname(vim.fs.dirname(shim))
    table.insert(candidates, typescript_dir .. "/node_modules/" .. pkg)
    table.insert(candidates, vim.fs.dirname(typescript_dir) .. "/" .. pkg)
  end
  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
end

vim.lsp.config("tsc", {
  cmd = function(dispatchers, config)
    local native = tsgo_native_binary(config.root_dir or vim.fn.getcwd())
    if not native then
      return vim.lsp.rpc.start({ "tsc", "--lsp", "--stdio" }, dispatchers)
    end
    return vim.lsp.rpc.start({ native, "--lsp", "--stdio" }, dispatchers, { env = { GOMEMLIMIT = tsgo_mem_limit } })
  end,
})

-- LSP server configs auto-discovered from ~/.config/nvim/lsp/*.lua
vim.lsp.enable(servers)

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  virtual_text = false,
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
