vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

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
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 15
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "130"
vim.lsp.inlay_hint.enable(true)
vim.opt.laststatus = 3
-- vim.opt.winborder = "rounded"

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

-- Import the runner module
local runner = require("bitrift.utils.runner")

vim.opt.showtabline = 0
vim.keymap.set("n", "<leader><leader>x", runner.run_file, { noremap = true, silent = false })
vim.keymap.set("v", "<leader>x", runner.run_selection, { noremap = true, silent = false })
vim.opt.conceallevel = 2
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
	end,
})
