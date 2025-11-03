local M = {}

local function show_output_popup(output, title)
	-- Create a buffer with the output
	local buf = vim.api.nvim_create_buf(false, true)
	local lines = vim.split(output, "\n")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- Calculate optimal size based on content
	local max_line_length = 0
	for _, line in ipairs(lines) do
		max_line_length = math.max(max_line_length, vim.fn.strdisplaywidth(line))
	end

	-- Add padding for borders and some breathing room
	local content_width = math.max(max_line_length, 20) + 4
	local content_height = #lines + 2

	-- Constrain to screen size (leave some margin)
	local max_width = math.floor(vim.o.columns * 0.9)
	local max_height = math.floor(vim.o.lines * 0.8)

	local width = math.min(content_width, max_width)
	local height = math.min(content_height, max_height)

	-- Center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create the window
	local win = vim.api.nvim_open_win(buf, true, {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		title = title or "Code Output",
		title_pos = "center",
	})

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "readonly", true)

	-- Set keymaps to close the popup
	local opts = { buffer = buf, silent = true }
	vim.keymap.set("n", "<CR>", function()
		vim.api.nvim_win_close(win, true)
	end, opts)
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, opts)
	vim.keymap.set("n", "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, opts)
end

function M.run_file()
	local ext = vim.fn.expand("%:e")
	local filename = vim.fn.expand("%")
	local runners = {
		js = function()
			return vim.fn.system("bun run " .. filename)
		end,
		py = function()
			return vim.fn.system("python3 " .. filename)
		end,
		sh = function()
			return vim.fn.system("bash " .. filename)
		end,
		go = function()
			return vim.fn.system("go run " .. filename)
		end,
		c = function()
			local output = vim.fn.system("gcc " .. filename .. " -o " .. vim.fn.expand("%:r"))
			if vim.v.shell_error == 0 then
				return vim.fn.system("./" .. vim.fn.expand("%:r"))
			else
				return output
			end
		end,
		cpp = function()
			local output = vim.fn.system("g++ " .. filename .. " -o " .. vim.fn.expand("%:r"))
			if vim.v.shell_error == 0 then
				return vim.fn.system("./" .. vim.fn.expand("%:r"))
			else
				return output
			end
		end,
		ts = function()
			return vim.fn.system("bun run " .. filename)
		end,
	}

	if runners[ext] then
		-- Save the file first
		vim.cmd("write")
		local output = runners[ext]()
		show_output_popup(output, ext:upper() .. " Output")
	else
		vim.notify("No runner defined for ." .. ext, vim.log.levels.WARN)
	end
end

function M.run_selection()
	local ext = vim.fn.expand("%:e")
	local tmpfile = "/tmp/vim_exec_tmp." .. ext

	-- Get visual selection
	vim.cmd('normal! "vy')
	local content = vim.fn.getreg("v")

	-- Write selection to temp file
	local f = io.open(tmpfile, "w")
	if not f then
		vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
		return
	end
	f:write(content)
	f:close()

	local runners = {
		js = function()
			return vim.fn.system("bun run " .. tmpfile)
		end,
		py = function()
			return vim.fn.system("python3 " .. tmpfile)
		end,
		sh = function()
			return vim.fn.system("bash " .. tmpfile)
		end,
		go = function()
			return vim.fn.system("go run " .. tmpfile)
		end,
		ts = function()
			return vim.fn.system("bun run " .. tmpfile)
		end,
	}

	if runners[ext] then
		local output = runners[ext]()
		show_output_popup(output, ext:upper() .. " Selection Output")
		-- Clean up temp file
		os.remove(tmpfile)
	else
		vim.notify("No runner defined for ." .. ext, vim.log.levels.WARN)
	end
end

return M
