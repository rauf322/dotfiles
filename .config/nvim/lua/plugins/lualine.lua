require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "vague",
    section_separators = { left = "", right = "" },
    component_separators = { left = "|", right = "|" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      {
        "filename",
        file_status = true,
        path = 0,
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
      },
      {
        "encoding",
        fmt = function(str)
          return str:upper()
        end,
      },
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = {
      function()
        local ok, opencode = pcall(require, "opencode")
        if ok then
          return opencode.statusline()
        end
        return ""
      end,
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        file_status = true,
        path = 1,
      },
    },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "fugitive" },
})
