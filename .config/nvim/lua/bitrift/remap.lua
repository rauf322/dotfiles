vim.g.mapleader = " "
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("i", "hh", "<Esc>")

-- split right (vertical)
vim.keymap.set("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical Split" })

-- split below (horizontal)
vim.keymap.set("n", "<leader>-", ":split<CR>", { desc = "Horizontal Split" })

-- close current window
vim.keymap.set("n", "<leader>x", ":close<CR>", { desc = "Close Split" })

-- toggle maximize window (requires 'szw/vim-maximizer')
vim.keymap.set("n", "<Leader>f", "<C-w>_<C-w>|", { desc = "full si[z]e" })
vim.keymap.set("n", "<Leader>F", "<C-w>=", { desc = "even si[Z]e" })
-- navigate between windows
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Focus Left" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Focus Right" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Focus Down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Focus Up" })

-- TODO Diagnostic Keymap
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Blank line below, stay in normal mode
vim.keymap.set("n", "<leader>o", ":put =''<CR>", { desc = "Blank line below (normal mode)" })

-- Blank line above, stay in normal mode
vim.keymap.set("n", "<leader>O", ":put! =''<CR>", { desc = "Blank line above (normal mode)" })

vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})
vim.keymap.set("n", "<leader>`", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 7)
end)
-- Resize window left with >
vim.keymap.set("n", ">", ":vertical resize +5<CR>", { noremap = true, silent = true })

-- Resize window right with <
vim.keymap.set("n", "<", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w>q", ":tabclose<CR>", { noremap = true, silent = true })
-- Map Esc to exit terminal mode and return to normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
