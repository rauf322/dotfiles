vim.opt.number = true
vim.opt.relativenumber = true
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 500
-- Save undo history
vim.opt.undofile = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "130"

vim.g.mapleader = " "
vim.opt.laststatus = 3
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
--execute the following command when entering a buffer in terminal mode
local function run_file()
	local ext = vim.fn.expand("%:e")
	local runners = {
		js = "w !node",
		py = "w !python3",
		sh = "w !bash",
		go = "w !go run",
		c = "!gcc % -o %:r && ./%:r",
		cpp = "!g++ % -o %:r && ./%:r",
	}
	if runners[ext] then
		vim.cmd(runners[ext])
	else
		print("No runner defined for ." .. ext)
	end
end

local function run_selection()
	local ext = vim.fn.expand("%:e")
	local tmpfile = "/tmp/vim_exec_tmp." .. ext
	vim.cmd('silent! normal! "vy') -- yank visual selection into register v
	local content = vim.fn.getreg("v")
	local f = io.open(tmpfile, "w")
	f:write(content)
	f:close()

	local runners = {
		js = "!node " .. tmpfile,
		py = "!python3 " .. tmpfile,
		sh = "!bash " .. tmpfile,
		go = "!go run " .. tmpfile,
	}

	if runners[ext] then
		vim.cmd(runners[ext])
	else
		print("No runner defined for ." .. ext)
	end
end
vim.opt.showtabline = 0
vim.keymap.set("n", "<leader><leader>x", run_file, { noremap = true, silent = false })
vim.keymap.set("v", "<leader>x", run_selection, { noremap = true, silent = false })
vim.opt.conceallevel = 2
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
	end,
})
-- put this in your main init.lua file ( before lazy setup )
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

-- put this after lazy setup
-- (method 2, for non lazyloaders) to load all highlights at once
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
