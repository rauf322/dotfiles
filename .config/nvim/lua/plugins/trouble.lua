require("trouble").setup({
  icons = false,
})

vim.keymap.set("n", "<leader>tt", function()
  require("trouble").toggle()
end, { desc = "Trouble: Toggle the Trouble window" })
vim.keymap.set("n", "[t", function()
  require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Trouble: Go to next item (skip groups)" })
vim.keymap.set("n", "]t", function()
  require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "Trouble: Go to previous item (skip groups)" })
