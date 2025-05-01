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
