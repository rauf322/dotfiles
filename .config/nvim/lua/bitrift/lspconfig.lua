local keymap = vim.keymap

-- Disabled inline completion (ghost text) - using nvim-cmp instead
-- vim.lsp.inline_completion.enable()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local buffer = ev.buf
    local opts = { buffer = buffer, silent = true }
    -- Standard LSP keymaps

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, opts)

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Show definiton of word (type)"
    keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end,
})

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
