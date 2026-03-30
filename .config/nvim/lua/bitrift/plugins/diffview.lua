require("diffview").setup({
  enhanced_diff_hl = true,
  view = {
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
})

vim.keymap.set("n", "<leader>gg", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: Open" })
vim.keymap.set("n", "<leader>gd", function()
  vim.ui.input({ prompt = "Compare with branch: " }, function(branch)
    if branch and branch ~= "" then
      vim.cmd("DiffviewOpen " .. branch)
    end
  end)
end, { desc = "Diffview: Compare with branch" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview: File History" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview: Branch History" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<CR>", { desc = "Diffview: Close" })
