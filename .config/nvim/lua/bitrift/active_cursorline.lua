-- Only highlight the cursor line in the active window
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
