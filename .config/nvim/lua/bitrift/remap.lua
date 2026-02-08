-- Leader
vim.g.mapleader = " "

local mappings = {
  -- Move lines / quality-of-life
  { mode = "v", key = "J", command = ":m '>+1<CR>gv=gv", opts = { silent = true, desc = "Move selection down" } },
  { mode = "v", key = "K", command = ":m '<-2<CR>gv=gv", opts = { silent = true, desc = "Move selection up" } },
  { mode = "n", key = "J", command = "mzJ`z" },
  { mode = "n", key = "n", command = "nzzzv" },
  { mode = "n", key = "N", command = "Nzzzv" },
  { mode = { "n", "v" }, key = "<leader>y", command = [["+y]] },
  { mode = { "n", "v" }, key = "<leader>d", command = '"_d' },

  -- Insert mode escape combos
  { mode = "i", key = "jj", command = "<Esc>" },
  { mode = "i", key = "kk", command = "<Esc>" },
  { mode = "i", key = "hh", command = "<Esc>" },

  -- Terminal mode escape
  { mode = "t", key = "<Esc>", command = "<C-\\><C-n>", opts = { desc = "Exit terminal mode" } },

  -- Reload plugins + config
  {
    mode = "n",
    key = "<leader>r",
    command = function()
      require("lazy").sync()
      vim.cmd("source $MYVIMRC")
      vim.notify("Lazy.nvim and config reloaded!", vim.log.levels.INFO)
    end,
    opts = { desc = "Reload lazy.nvim and Neovim config" },
  },

  -- Splits
  { mode = "n", key = "<leader>|", command = ":vsplit<CR>", opts = { desc = "Vertical Split" } },
  { mode = "n", key = "<leader>-", command = ":split<CR>", opts = { desc = "Horizontal Split" } },

  -- Maximize / equalize
  { mode = "n", key = "<Leader>f", command = "<C-w>_<C-w>|", opts = { desc = "full si[z]e" } },
  { mode = "n", key = "<Leader>w=", command = "<C-w>=", opts = { desc = "even si[Z]e" } },

  -- Window navigation
  { mode = "n", key = "<leader>h", command = "<C-w>h", opts = { desc = "Focus Left" } },
  { mode = "n", key = "<leader>l", command = "<C-w>l", opts = { desc = "Focus Right" } },
  { mode = "n", key = "<leader>j", command = "<C-w>j", opts = { desc = "Focus Down" } },
  { mode = "n", key = "<leader>k", command = "<C-w>k", opts = { desc = "Focus Up" } },

  -- Window movement (swap window positions)
  { mode = "n", key = "<leader>wH", command = "<C-w>H", opts = { desc = "Move window left" } },
  { mode = "n", key = "<leader>wL", command = "<C-w>L", opts = { desc = "Move window right" } },
  { mode = "n", key = "<leader>wJ", command = "<C-w>J", opts = { desc = "Move window down" } },
  { mode = "n", key = "<leader>wK", command = "<C-w>K", opts = { desc = "Move window up" } },

  -- Blank lines without leaving normal mode
  { mode = "n", key = "<leader>o", command = ":put =''<CR>", opts = { desc = "Blank line below" } },
  { mode = "n", key = "<leader>O", command = ":put! =''<CR>", opts = { desc = "Blank line above" } },

  -- Window resizing
  { mode = "n", key = "<leader>wl", command = ":vertical resize -25<CR>", opts = { desc = "Resize narrower" } },
  { mode = "n", key = "<leader>wh", command = ":vertical resize +25<CR>", opts = { desc = "Resize wider" } },
  { mode = "n", key = "<leader>wj", command = ":resize +25<CR>", opts = { desc = "Resize taller" } },
  { mode = "n", key = "<leader>wk", command = ":resize -25<CR>", opts = { desc = "Resize shorter" } },
}

for _, mapping in ipairs(mappings) do
  vim.keymap.set(mapping.mode, mapping.key, mapping.command, mapping.opts or {})
end
