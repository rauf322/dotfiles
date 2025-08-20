local M = {}

local Term = { bufnr = nil, winid = nil }

function M.toggle()
	-- Hide if terminal window is open
	if Term.winid and vim.api.nvim_win_is_valid(Term.winid) then
		vim.api.nvim_win_hide(Term.winid)
		Term.winid = nil
		return
	end

	-- Reopen existing terminal buffer
	if Term.bufnr and vim.api.nvim_buf_is_valid(Term.bufnr) then
		vim.cmd("botright 7split")
		vim.api.nvim_win_set_buf(0, Term.bufnr)
		Term.winid = vim.api.nvim_get_current_win()
		-- vim.cmd("startinsert")
		return
	end

	-- Otherwise create new terminal
	vim.cmd("botright 7split")
	Term.winid = vim.api.nvim_get_current_win()
	Term.bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(Term.winid, Term.bufnr)
	vim.fn.termopen(vim.o.shell)
	vim.bo[Term.bufnr].buftype = "terminal"
	vim.bo[Term.bufnr].buflisted = false
	-- vim.cmd("startinsert")
end

-- Setup function to define keymaps/autocmds
function M.setup()
	vim.keymap.set("n", "<leader>`", M.toggle, { desc = "Toggle terminal" })

	vim.api.nvim_create_autocmd("TermOpen", {
		callback = function(args)
			vim.keymap.set("n", "<C-w>q", function()
				if Term.winid and vim.api.nvim_get_current_win() == Term.winid then
					M.toggle()
				else
					vim.cmd("close")
				end
			end, { buffer = args.buf, silent = true })
		end,
	})
end

return M
