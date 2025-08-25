vim.api.nvim_create_augroup("DapGroup", { clear = true })
return {
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		config = function()
			local dap = require("dap")
			dap.set_log_level("DEBUG")

			-- Set up the js-debug adapter using Mason
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug-adapter", -- This is the name Mason provides
					args = { "${port}" },
				},
			}

			-- Configure JavaScript launch configurations
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}

			-- Configure TypeScript launch configurations (same as JavaScript)
			dap.configurations.typescript = {
				-- {
				-- 	type = "pwa-node",
				-- 	request = "launch",
				-- 	name = "Launch file",
				-- 	program = "${file}",
				-- 	cwd = "${workspaceFolder}",
				-- 	sourceMaps = true,
				-- },
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch TypeScript file (ts-node)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeArgs = { "-r", "ts-node/register" },
					sourceMaps = true,
				},
			}

			-- Configure TypeScript React
			dap.configurations.typescriptreact = dap.configurations.typescript

			-- Configure JavaScript React
			dap.configurations.javascriptreact = dap.configurations.javascript

			-- Key mappings for debugging
			vim.keymap.set("n", "<F4>", dap.continue, { desc = "DAP: Continue" })
			vim.keymap.set("n", "<F5>", dap.step_over, { desc = "DAP: Step Over" })
			vim.keymap.set("n", "<F6>", dap.step_into, { desc = "DAP: Step Into" })
			vim.keymap.set("n", "<F7>", dap.step_out, { desc = "DAP: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP: Conditional Breakpoint" })

			-- Disable global statusline during DAP sessions
			vim.api.nvim_create_autocmd("User", {
				group = "DapGroup",
				pattern = "DapStarted",
				callback = function()
					vim.o.statusline = "" -- Clear global statusline
					vim.o.laststatus = 0 -- Hide statusline globally
				end,
			})
			-- Restore global statusline when DAP session ends
			vim.api.nvim_create_autocmd("User", {
				group = "DapGroup",
				pattern = { "DapStopped", "DapTerminated", "DapExited" },
				callback = function()
					vim.o.statusline = "%f %y" -- Restore to a simple statusline
					vim.o.laststatus = 2 -- Restore default statusline visibility
				end,
			})
			-- Disable statusline for DAP UI buffers (scopes, breakpoints, stacks)
			vim.api.nvim_create_autocmd("BufWinEnter", {
				group = "DapGroup",
				pattern = { "dapui_scopes", "dapui_breakpoints", "dapui_stacks" },
				callback = function()
					vim.wo.statusline = "" -- Set buffer-local statusline to empty
				end,
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			-- Setup DAP UI with default layout
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
			})
			-- Single keybinding to toggle the entire UI
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "DAP: Toggle DAP UI" })
			vim.keymap.set("n", "<leader>de", function()
				dapui.close()
				dapui.open({ reset = true })
				vim.cmd("wincmd =")
			end, { desc = "DAP: Equalize all windows including DAP UI" })
			-- Auto-close UI when debugging ends
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
