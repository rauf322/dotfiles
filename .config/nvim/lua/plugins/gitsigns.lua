require("gitsigns").setup({
  current_line_blame = true,
})
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Gitsigns preview hunk" })
vim.keymap.set({ "n", "v" }, "<leader>ga", ":Gitsigns <Tab>", { desc = "Gitsigns actions" })
vim.keymap.set({ "n", "v" }, "<leader>sh", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns: Stage hunk" })
vim.keymap.set("n", "<leader>uh", ":Gitsigns undo_stage_hunk<CR>", { desc = "Gitsigns: Unstage hunk" })
