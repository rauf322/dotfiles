require("rose-pine").setup({
  disable_background = true,
  styles = {
    italic = false,
  },
})

require("vague").setup({
  transparent = true,
  bold = true,
  italic = false,
})

function ColorMyPencils(color)
  color = color or "vague"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  -- Border color sampled from reference screenshot; titles catppuccin mauve.
  -- Snacks/blink capture FloatBorder during the colorscheme call above, so
  -- their groups must be re-linked here to pick up the override.
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#b2d3cf", bg = "none" })
  vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#F4F5F0", bg = "none" })

  local border_groups = {
    "SnacksInputBorder",
    "SnacksPickerBorder",
    "SnacksPickerInputBorder",
    "SnacksPickerBoxBorder",
    "SnacksPickerListBorder",
    "SnacksPickerPreviewBorder",
    "SnacksNotifierBorder",
    "BlinkCmpMenuBorder",
    "BlinkCmpDocBorder",
    "BlinkCmpSignatureHelpBorder",
  }
  for _, group in ipairs(border_groups) do
    vim.api.nvim_set_hl(0, group, { link = "FloatBorder" })
  end

  local title_groups = {
    "SnacksInputTitle",
    "SnacksPickerTitle",
    "SnacksPickerInputTitle",
    "SnacksPickerBoxTitle",
    "SnacksPickerListTitle",
    "SnacksPickerPreviewTitle",
  }
  for _, group in ipairs(title_groups) do
    vim.api.nvim_set_hl(0, group, { link = "FloatTitle" })
  end
end

ColorMyPencils()
