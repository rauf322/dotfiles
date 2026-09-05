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

-- Trial of dmmulroy's catppuccin setup (github.com/dmmulroy/.dotfiles), integrations
-- trimmed to the plugins actually installed here. Solid background on purpose to
-- match his look; flip `transparent_background` to get the usual transparent one.
require("catppuccin").setup({
  flavour = "macchiato",
  transparent_background = false,
  integrations = {
    blink_cmp = true,
    dadbod_ui = true,
    dashboard = true,
    diffview = true,
    flash = true,
    gitsigns = true,
    lsp_saga = true,
    lsp_trouble = true,
    mason = true,
    mini = { enabled = true },
    native_lsp = { enabled = true },
    noice = true,
    notify = true,
    render_markdown = true,
    snacks = {
      enabled = true,
      indent_scope_color = "mauve",
    },
    treesitter = true,
    treesitter_context = true,
    which_key = true,
  },
})

-- Single source of truth is the ghostty theme symlink (flipped by `theme` / :Theme),
-- so terminal and editor always agree.
local ghostty_theme_link = vim.fn.expand("~/.config/ghostty/theme")
local switch_theme_script = vim.fn.expand("~/.local/scripts/theme")
local colorscheme_for = { vague = "vague", catppuccin = "catppuccin-macchiato" }

local function current_theme()
  local link = vim.uv.fs_readlink(ghostty_theme_link)
  return link and vim.fs.basename(link) or "vague"
end

function ColorMyPencils(color)
  color = color or colorscheme_for[current_theme()] or "vague"
  vim.cmd.colorscheme(color)

  if color:match("^catppuccin") then
    -- dmmulroy hides all semantic highlights so treesitter colors win
    -- (https://github.com/catppuccin/nvim/issues/480). Kept for a faithful trial.
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end
    return
  end

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1a1a1a" })

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

vim.api.nvim_create_user_command("Theme", function(opts)
  local cmd = { switch_theme_script }
  if opts.args ~= "" then
    table.insert(cmd, opts.args)
  end
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
    return
  end
  ColorMyPencils()
  vim.notify(vim.trim(result.stdout))
end, {
  nargs = "?",
  complete = function()
    return vim.tbl_keys(colorscheme_for)
  end,
  desc = "Switch ghostty + nvim theme (no arg = toggle)",
})

ColorMyPencils()
