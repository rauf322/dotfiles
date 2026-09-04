require("package-info").setup({
  autostart = true,
  hide_up_to_date = true,
})

vim.keymap.set("n", "<leader>ns", function()
  require("package-info").show()
end, { desc = "Package: Show versions" })
vim.keymap.set("n", "<leader>nu", function()
  require("package-info").update()
end, { desc = "Package: Update dependency" })
vim.keymap.set("n", "<leader>nd", function()
  require("package-info").delete()
end, { desc = "Package: Delete dependency" })
vim.keymap.set("n", "<leader>ni", function()
  require("package-info").install()
end, { desc = "Package: Install dependency" })
vim.keymap.set("n", "<leader>np", function()
  require("package-info").change_version()
end, { desc = "Package: Change version" })
vim.keymap.set("n", "<leader>nt", function()
  require("package-info").toggle()
end, { desc = "Package: Toggle versions" })
