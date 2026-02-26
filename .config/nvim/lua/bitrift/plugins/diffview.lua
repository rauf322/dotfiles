return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gg", "<cmd>DiffviewOpen<CR>", desc = "Diffview: Open" },
    {
      "<leader>gd",
      function()
        vim.ui.input({ prompt = "Compare with branch: " }, function(branch)
          if branch and branch ~= "" then
            vim.cmd("DiffviewOpen " .. branch)
          end
        end)
      end,
      desc = "Diffview: Compare with branch",
    },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: File History" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview: Branch History" },
    { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diffview: Close" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  },
}
