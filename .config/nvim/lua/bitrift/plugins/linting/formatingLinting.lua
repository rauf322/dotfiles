local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    javascript = { "oxfmt", "prettierd", stop_after_first = true },
    typescript = { "oxfmt", "prettierd", stop_after_first = true },
    javascriptreact = { "oxfmt", "prettierd", stop_after_first = true },
    typescriptreact = { "oxfmt", "prettierd", stop_after_first = true },
    svelte = { "prettierd" },
    css = { "prettierd" },
    html = { "prettierd" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    yaml = { "prettierd" },
    markdown = { "prettierd" },
    graphql = { "prettierd" },
    liquid = { "prettierd" },
    lua = { "stylua" },
    python = { "isort", "black" },
    go = { "goimports", "gofumpt" },
    rust = { "rustfmt" },
  },
  formatters = {
    stylua = {
      args = {
        "--stdin-filepath",
        "$FILENAME",
        "-",
      },
    },
  },
  format_on_save = {
    async = false,
    lsp_fallback = false,
  },
})

vim.keymap.set({ "n", "v" }, "<leader>s", function()
  local ok, err = pcall(function()
    local ok_req, jsx_autofix = pcall(require, "bitrift.utils.jsx-autofix")
    if ok_req and jsx_autofix and type(jsx_autofix.fix_jsx_self_closing) == "function" then
      local ok_fix, fix_err = pcall(jsx_autofix.fix_jsx_self_closing)
      if not ok_fix then
        vim.notify("JSX autofix failed: " .. tostring(fix_err), vim.log.levels.WARN)
      end
    end

    vim.wait(10)

    if type(conform) == "table" and type(conform.format) == "function" then
      local ok_fmt, fmt_err = pcall(function()
        conform.format({
          lsp_fallback = true,
          async = false,
          quiet = true,
        })
      end)
      if not ok_fmt then
        vim.notify("Formatting failed: " .. tostring(fmt_err) .. ". Saving without formatting.", vim.log.levels.WARN)
      end
    else
      vim.notify("conform.format not available; saving without formatting", vim.log.levels.WARN)
    end

    vim.wait(50)

    vim.cmd("wa")
  end)

  if not ok then
    vim.notify("Format and save operation failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end, { desc = "Format file(s) and save" })
