-- Auto-fix JSX completions to use self-closing tags
vim.api.nvim_create_autocmd("CompleteDone", {
	pattern = "*.jsx,*.tsx",
	callback = function()
		-- Get the current line
		local line = vim.api.nvim_get_current_line()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		
		-- Pattern to match <Component></Component> (empty JSX tags)
		local jsx_pattern = "(<[A-Z][%w]*[^/>]*)></[A-Z][%w]*>"
		
		-- Check if the current line has the pattern
		local match = line:match(jsx_pattern)
		if match then
			-- Replace with self-closing version
			local new_line = line:gsub(jsx_pattern, "%1 />")
			vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
			
			-- Adjust cursor position (self-closing is shorter)
			local diff = #line - #new_line
			vim.api.nvim_win_set_cursor(0, { row, math.max(0, col - diff) })
		end
	end,
})

-- Alternative: Auto-fix on InsertLeave for JSX files
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*.jsx,*.tsx",
	callback = function()
		-- Get the current line
		local line = vim.api.nvim_get_current_line()
		local row = vim.api.nvim_win_get_cursor(0)[1]
		
		-- Pattern to match <Component></Component> (empty JSX tags)
		local jsx_pattern = "(<[A-Z][%w]*[^/>]*)></[A-Z][%w]*>"
		
		-- Check if the current line has the pattern
		if line:match(jsx_pattern) then
			-- Replace with self-closing version
			local new_line = line:gsub(jsx_pattern, "%1 />")
			vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
		end
	end,
})

return {}