-- Leader
vim.g.mapleader = " "

-- Move lines / quality-of-life
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Insert mode escape combos
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("i", "hh", "<Esc>")

-- Reload plugins + config
vim.keymap.set("n", "<leader>r", function()
	require("lazy").sync()
	vim.cmd("source $MYVIMRC")
	vim.notify("Lazy.nvim and config reloaded!", vim.log.levels.INFO)
end, { desc = "Reload lazy.nvim and Neovim config" })

-- Splits
vim.keymap.set("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>-", ":split<CR>", { desc = "Horizontal Split" })

-- Buffers / windows
vim.keymap.set("n", "<leader>qq", ":bdelete!<CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "qb", function()
	local bufnr = vim.api.nvim_get_current_buf()

	-- close only the current window

	vim.cmd("close")
	-- if the buffer is not displayed in any window, delete it
	if vim.fn.bufwinnr(bufnr) == -1 then
		vim.cmd("bdelete! " .. bufnr)
	end

	-- safety: if there are no listed buffers left, create a new empty one
	if vim.fn.bufnr("$") == 0 or vim.fn.buflisted(vim.fn.bufnr()) == 0 then
		vim.cmd("enew") -- create an empty buffer
	end
end, { desc = "Close current window (delete buffer if unused, keep one buffer open)" })

-- Maximize / equalize
vim.keymap.set("n", "<Leader>f", "<C-w>_<C-w>|", { desc = "full si[z]e" })
vim.keymap.set("n", "<Leader>F", "<C-w>=", { desc = "even si[Z]e" })

-- Window navigation
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Focus Left" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Focus Right" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Focus Down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Focus Up" })

-- Blank lines without leaving normal mode
vim.keymap.set("n", "<leader>o", ":put =''<CR>", { desc = "Blank line below" })
vim.keymap.set("n", "<leader>O", ":put! =''<CR>", { desc = "Blank line above" })

-- Terminal UI tweaks (keep if you like numbers off in terminals)
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

-- Resize (arrow or hjkl flavor — pick one set you prefer)
vim.keymap.set("n", "<leader><Left>", ":vertical resize -25<CR>", { desc = "Narrower window" })
vim.keymap.set("n", "<leader><Right>", ":vertical resize +25<CR>", { desc = "Wider window" })
vim.keymap.set("n", "<leader><Down>", ":resize +25<CR>", { desc = "Taller window" })
vim.keymap.set("n", "<leader><Up>", ":resize -25<CR>", { desc = "Shorter window" })

vim.keymap.set("n", "<leader>rh", ":vertical resize -25<CR>", { desc = "Resize narrower" })
vim.keymap.set("n", "<leader>rl", ":vertical resize +25<CR>", { desc = "Resize wider" })
vim.keymap.set("n", "<leader>rj", ":resize +25<CR>", { desc = "Resize taller" })
vim.keymap.set("n", "<leader>rk", ":resize -25<CR>", { desc = "Resize shorter" })

-- Tab close
vim.keymap.set("n", "<C-w>q", ":tabclose<CR>", { noremap = true, silent = true })

-- Terminal: Esc to Normal
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
