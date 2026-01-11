return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

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
							severity = message.severity == 1 and vim.diagnostic.severity.WARN
								or vim.diagnostic.severity.ERROR,
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
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					svelte = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					jsonc = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					graphql = { "prettierd" },
					liquid = { "prettierd" },
					lua = { "stylua" },
					python = { "isort", "black" },
					go = { "goimports", "gofumpt" },
				},
				formatters = {
					-- prettier = {
					-- 	args = {
					-- 		"--stdin-filepath",
					-- 		"$FILENAME",
					-- 		"--single-quote",
					-- 		"--jsx-single-quote",
					-- 		-- "--print-width=140",
					-- 	},
					-- },
					stylua = {
						args = {
							-- "--column-width=140",
							"--stdin-filepath",
							"$FILENAME",
							"-",
						},
					},
				},
				format_on_save = {
					async = false,
					lsp_fallback = false,
				},
			})
			vim.keymap.set({ "n", "v" }, "<leader>s", function()
				-- Wrap the whole operation and capture any error message
				local ok, err = pcall(function()
					-- require the jsx-autofix safely
					local ok_req, jsx_autofix = pcall(require, "bitrift.utils.jsx-autofix")
					if ok_req and jsx_autofix and type(jsx_autofix.fix_jsx_self_closing) == "function" then
						-- run the JSX fixer, but protect it as well
						local ok_fix, fix_err = pcall(jsx_autofix.fix_jsx_self_closing)
						if not ok_fix then
							vim.notify("JSX autofix failed: " .. tostring(fix_err), vim.log.levels.WARN)
						end
					end

					-- small wait to let LSP / buffer updates settle
					vim.wait(10)

					-- Format with conform, but check that conform exists and has format
					if type(conform) == "table" and type(conform.format) == "function" then
						local ok_fmt, fmt_err = pcall(function()
							conform.format({
								lsp_fallback = true,
								async = false,
								quiet = true,
							})
						end)
						if not ok_fmt then
							vim.notify(
								"Formatting failed: " .. tostring(fmt_err) .. ". Saving without formatting.",
								vim.log.levels.WARN
							)
						end
					else
						vim.notify("conform.format not available; saving without formatting", vim.log.levels.WARN)
					end

					-- Wait a bit to let formatting complete if any
					vim.wait(50)

					-- Save all changed buffers
					vim.cmd("wa")
				end)

				if not ok then
					-- show the actual error so you can debug why pcall failed
					vim.notify("Format and save operation failed: " .. tostring(err), vim.log.levels.ERROR)
				end
			end, { desc = "Format file(s) and save" })
		end,
	},
}
