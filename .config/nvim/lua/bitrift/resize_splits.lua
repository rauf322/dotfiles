-- Equalize splits when the terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})
