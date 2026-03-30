vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1a1a1a" })
require("notify").setup({
  timeout = 200,
  background_colour = "#0000",
})

require("noice").setup({
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
          { find = "%d fewer lines" },
          { find = "%d more lines" },
        },
      },
      opts = { skip = true },
    },
    {
      filter = { event = "notify", find = "ESLint output parsing failed" },
      opts = { skip = true },
    },
    {
      filter = { event = "notify", find = "No information available" },
      opts = { skip = true },
    },
    {
      filter = { event = "notify", find = "Neo%-tree.*Toggling hidden files" },
      opts = { skip = true },
    },
    {
      filter = { event = "notify", find = "No code actions available" },
      opts = { skip = true },
    },
    {
      filter = { event = "notify", find = "no code action available" },
      opts = { skip = true },
    },
    {
      filter = { event = "notify", find = "No code action" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", find = "no code action" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", find = "No code action" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", find = "attempt to get length of local 'prev_line'" },
      opts = { skip = true },
    },
    {
      filter = { event = "msg_show", find = "Error executing lua callback.*sync%.lua" },
      opts = { skip = true },
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
  messages = {
    enabled = true,
    view = "mini",
    view_error = "mini",
    view_warn = "mini",
    view_history = "mini",
    view_search = "mini",
  },
  notify = {
    enabled = true,
    view = "mini",
  },
  lsp = {
    message = {
      enabled = true,
      view = "mini",
    },
    signature = {
      enabled = true,
      opts = {
        size = {
          max_height = 15,
          max_width = 80,
        },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = "40%",
          col = "50%",
        },
      },
      mini = {
        timeout = vim.g.neovim_mode == "skitty" and 2000 or 5000,
        align = "center",
        position = {
          row = "95%",
          col = "100%",
        },
      },
    },
  },
})
