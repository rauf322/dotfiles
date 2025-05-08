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

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

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
    vert = ' ',
    fold = '┈',
    diff = '┈',
    horiz = ' ',
    horizup = ' ',
    horizdown = ' ',
    vertleft = ' ',
    vertright = ' ',
    verthoriz = ' ',
}
--execute the following command when entering a buffer in terminal mode
local function run_file()
    local ext = vim.fn.expand('%:e')
    local runners = {
        js = 'w !node',
        py = 'w !python3',
        sh = 'w !bash',
        go = 'w !go run',
        c = '!gcc % -o %:r && ./%:r',
        cpp = '!g++ % -o %:r && ./%:r',
    }
    if runners[ext] then
        vim.cmd(runners[ext])
    else
        print('No runner defined for .' .. ext)
    end
end

vim.keymap.set('n', '<C-r>', run_file, { noremap = true, silent = false })
