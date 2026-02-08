return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300, -- delay before showing which-key popup (ms)
    preset = "modern", -- modern or classic style
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
    },
    show_help = false, -- hide help text at bottom
    show_keys = true, -- show actual key combinations
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Add group names for leader key combinations
    wk.add({
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find/Files" },
      { "<leader>g", group = "Git" },
      { "<leader>p", group = "Project" },
      { "<leader>w", group = "Window" },
    })
  end,
}
