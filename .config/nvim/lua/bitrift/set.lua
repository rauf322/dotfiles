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
vim.opt.smartindent = true
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

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
	desc = "Highlight references under cursor",
	callback = function()
		if vim.fn.mode() ~= "i" then
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			local supports_highlight = false
			for _, client in ipairs(clients) do
				if client.server_capabilities.documentHighlightProvider then
					supports_highlight = true
					break
				end
			end

			if supports_highlight then
				vim.lsp.buf.clear_references()
				vim.lsp.buf.document_highlight()
			end
		end
	end,
})

vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertEnter" }, {
	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = false }),
	desc = "Clear highlights when entering insert mode",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
