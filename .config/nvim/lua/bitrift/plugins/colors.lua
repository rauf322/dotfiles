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
end

ColorMyPencils()
