-- runner.lua
local M = {}

function M.run_file()
	local ext = vim.fn.expand("%:e")
	local runners = {
		js = "w !node",
		py = "w !python3",
		sh = "w !bash",
		go = "w !go run",
		c = "!gcc % -o %:r && ./%:r",
		cpp = "!g++ % -o %:r && ./%:r",
		ts = "w !ts-node", -- Fixed: added the missing !
	}
	if runners[ext] then
		vim.cmd(runners[ext])
	else
		print("No runner defined for ." .. ext)
	end
end

function M.run_selection()
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
		ts = "!ts-node " .. tmpfile, -- Fixed: added space after ts-node
	}

	if runners[ext] then
		vim.cmd(runners[ext])
	else
		print("No runner defined for ." .. ext)
	end
end

return M
