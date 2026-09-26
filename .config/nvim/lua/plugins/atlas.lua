require("atlas").setup({
  providers = {
    bitbucket = {
      user = vim.env.BITBUCKET_USER,
      token = vim.env.BITBUCKET_TOKEN,
    },
  },
  pulls = {
    default_merge_method = "merge",
    diff = {
      open_cmd = "CodeDiff", -- reuse our codediff.nvim instead of native AtlasDiff
    },
  },
})

vim.keymap.set("n", "<leader>gb", "<cmd>Atlas pulls bitbucket<CR>", { desc = "Atlas: Bitbucket PRs" })
vim.keymap.set("n", "<leader>gr", "<cmd>Atlas review<CR>", { desc = "Atlas: Review PR" })
