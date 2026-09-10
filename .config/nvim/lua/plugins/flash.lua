require("flash").setup({
  modes = {
    search = {
      enabled = false,
    },
    -- f/F/t/T are owned by mini.jump; the `s` prefix is owned by mini.surround
    char = {
      enabled = false,
    },
  },
})

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
