-- Set leader key to space
vim.g.mapleader = " "

vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable ignorecase + smartcase for better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 500

-- Save undo history
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = false

-- Disable text wrap by default, but enable it for Markdown buffers
vim.opt.wrap = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.guicursor = "a:block"
vim.opt.scrolloff = 15
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.updatetime = 250
vim.opt.colorcolumn = "80"
vim.opt.laststatus = 3

-- vim.opt.winborder = "rounded"

vim.g.no_plugin_maps = true

-- Disable unnecessary providers to eliminate checkhealth warnings
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.opt.fillchars = {
  vert = " ",
  fold = "┈",
  diff = "┈",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  vertleft = " ",
  vertright = " ",
  verthoriz = " ",
}

-- Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent = true

-- Enable cursor line highlight
vim.opt.cursorline = true

vim.opt.showtabline = 0
vim.opt.conceallevel = 2
