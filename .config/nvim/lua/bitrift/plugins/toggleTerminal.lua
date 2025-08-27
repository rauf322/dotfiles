return {
	"voldikss/vim-floaterm",
	config = function()
		-- Floaterm configuration
		vim.g.floaterm_width = 0.8
		vim.g.floaterm_height = 0.8
		vim.g.floaterm_position = "center"
		vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
		vim.g.floaterm_title = ""
		vim.g.floaterm_autoinsert = false
		vim.g.floaterm_autoclose = 2 -- Close terminal window when job finishes

		-- Keymaps
		vim.keymap.set("n", "<leader>`", ":FloatermToggle<CR>", { desc = "Toggle floating terminal" })
		vim.keymap.set("t", "<leader>`", "<C-\\><C-n>:FloatermToggle<CR>", { desc = "Toggle floating terminal" })
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
	end,
}
