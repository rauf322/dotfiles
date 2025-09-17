return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Override eslint_d with more robust configuration
			lint.linters.eslint_d = {
				cmd = "eslint_d",
				stdin = true,
				args = {
					"--format",
					"json",
					"--stdin",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
				},
				stream = "stdout",
				ignore_exitcode = true,
				parser = function(output, bufnr)
					if output == "" then
						return {}
					end

					local ok, result = pcall(vim.json.decode, output)
					if not ok then
						vim.notify("ESLint output parsing failed: " .. tostring(result), vim.log.levels.WARN)
						return {}
					end

					if not result or not result[1] or not result[1].messages then
						return {}
					end

					local diagnostics = {}
					for _, message in ipairs(result[1].messages) do
						table.insert(diagnostics, {
							lnum = message.line - 1,
							col = message.column - 1,
							end_lnum = message.endLine and (message.endLine - 1) or (message.line - 1),
							end_col = message.endColumn and (message.endColumn - 1) or (message.column - 1),
							severity = message.severity == 1 and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR,
							message = message.message,
							source = "eslint_d",
							code = message.ruleId,
						})
					end

					return diagnostics
				end,
			}
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				python = { "pylint" },
			}
			local grp = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = grp,
				callback = function()
					lint.try_lint()
				end,
			})
			vim.keymap.set("n", "<leader>tl", function()
				lint.try_lint()
			end, { desc = "Trigger linting" })
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					liquid = { "prettier" },
					lua = { "stylua" },
					python = { "isort", "black" },
				},
				formatters = {
					prettier = {
						args = {
							"--stdin-filepath",
							"$FILENAME",
							"--single-quote",
							"--jsx-single-quote",
							-- "--print-width=140",
						},
					},
					stylua = {
						args = {
							-- "--column-width=140",
							"--stdin-filepath",
							"$FILENAME",
							"-",
						},
					},
				},
				format_on_save = { lsp_fallback = true, async = false, timeout_ms = 500 },
			})

			vim.keymap.set({ "n", "v" }, "<leader>s", function()
				-- First run JSX self-closing fix if it's a JSX/TSX file
				local jsx_autofix = require("bitrift.utils.jsx-autofix")
				jsx_autofix.fix_jsx_self_closing()

				-- Then format with conform
				conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
				
				-- Use pcall to handle save errors gracefully
				local ok, err = pcall(function()
					vim.cmd("wa")
				end)
				
				if not ok then
					-- If normal save fails, try force save
					vim.notify("Normal save failed, trying force save...", vim.log.levels.WARN)
					vim.cmd("wa!")
				end
			end, { desc = "Format file(s) and save" })
		end,
	},
}
