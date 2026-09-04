require("auto-session").setup({
  suppressed_dirs = { "~/", "~/Downloads", "/" },
  session_lens = {
    picker = "snacks",
  },
  pre_save_cmds = {
    function()
      pcall(function()
        require("oil").close()
      end)
    end,
  },
})

vim.keymap.set("n", "<leader>ss", "<cmd>AutoSession save<cr>", { desc = "Save session" })
vim.keymap.set("n", "<leader>sr", "<cmd>AutoSession restore<cr>", { desc = "Restore session" })
vim.keymap.set("n", "<leader>sd", "<cmd>AutoSession delete<cr>", { desc = "Delete session" })
vim.keymap.set("n", "<leader>sf", "<cmd>AutoSession search<cr>", { desc = "Search sessions" })
