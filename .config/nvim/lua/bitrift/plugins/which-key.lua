local wk = require("which-key")
wk.setup({
  delay = 300,
  preset = "modern",
  win = {
    border = "rounded",
    padding = { 1, 2 },
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
  },
  show_help = false,
  show_keys = true,
})

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
