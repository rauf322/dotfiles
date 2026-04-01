
require("dashboard").setup({
  theme = "hyper",
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      {
        icon = " ",
        icon_hl = "@variable",
        desc = "Find File",
        group = "Label",
        action = "lua Snacks.picker.files()",
        key = "f",
      },
      {
        icon = " ",
        desc = "Find Text",
        group = "DiagnosticHint",
        action = "lua Snacks.picker.grep()",
        key = "g",
      },
      {
        icon = " ",
        desc = "Recent Files",
        group = "Number",
        action = "lua Snacks.picker.recent()",
        key = "r",
      },
      {
        icon = " ",
        desc = "Config",
        group = "@property",
        action = "lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
        key = "c",
      },
      {
        icon = "📦 ",
        desc = "Update",
        group = "@property",
        action = "lua vim.pack.update()",
        key = "u",
      },
    },
    project = {
      enable = true,
      limit = 8,
      icon = " ",
      label = "Recent Projects",
      action = "lua Snacks.picker.files({ cwd = ",
    },
    mru = {
      enable = true,
      limit = 10,
      icon = " ",
      label = "Recent Files",
      cwd_only = false,
    },
    footer = {},
  },
})
