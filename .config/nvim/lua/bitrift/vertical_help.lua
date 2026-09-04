-- Open help windows as a vertical split on the right
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})
