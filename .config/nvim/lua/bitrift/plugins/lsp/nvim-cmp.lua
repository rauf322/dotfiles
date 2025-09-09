return {
	{
		"hrsh7th/nvim-cmp",
		-- event = "InsertEnter",
		branch = "main", -- fix for deprecated functions coming in nvim 0.13
		dependencies = {
			"hrsh7th/cmp-buffer", -- source for text in buffer
			"hrsh7th/cmp-path", -- source for file system paths
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip", -- autocompletion
			"rafamadriz/friendly-snippets", -- snippets
			"nvim-treesitter/nvim-treesitter",
			"onsails/lspkind.nvim", -- vs-code pictograms
			"roobert/tailwindcss-colorizer-cmp.nvim",
		},

		config = function()
			local cmp = require("cmp")
			local has_luasnip, luasnip = pcall(require, "luasnip")
			local lspkind = require("lspkind")

			-- Load custom snippets from the specified path
			local lsp_kinds = {
				Class = " ",
				Color = " ",
				Constant = " ",
				Constructor = " ",
				Enum = " ",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = " ",
				Folder = " ",
				Function = " ",
				Interface = " ",
				Keyword = " ",
				Method = " ",
				Module = " ",
				Operator = " ",
				Property = " ",
				Reference = " ",
				Snippet = " ",
				Struct = " ",
				Text = " ",
				TypeParameter = " ",
				Unit = " ",
				Value = " ",
				Variable = " ",
			}

			local select_next_item = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end

			local select_prev_item = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end

			-- NOTE: Until https://github.com/hrsh7th/nvim-cmp/issues/1716
			-- (cmp.ConfirmBehavior.MatchSuffix) gets implemented, use this local wrapper
			-- to choose between `cmp.ConfirmBehavior.Insert` and `cmp.ConfirmBehavior.Replace`:
			local confirm = function(entry)
				local behavior = cmp.ConfirmBehavior.Replace
				if entry then
					local completion_item = entry.completion_item
					local newText = ""
					if completion_item.textEdit then
						newText = completion_item.textEdit.newText
					elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
						newText = completion_item.insertText
					else
						newText = completion_item.word or completion_item.label or ""
					end

					-- checks how many characters will be different after the cursor position if we replace?
					local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col

					-- does the text that will be replaced after the cursor match the suffix
					-- of the `newText` to be inserted ? if not, then `Insert` instead.
					if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
						behavior = cmp.ConfirmBehavior.Insert
					end
				end
				cmp.confirm({ select = true, behavior = behavior })
			end

			-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				experimental = {
					-- HACK: experimenting with ghost text
					-- look at `toggle_ghost_text()` function below.
					ghost_text = true,
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				window = {
					documentation = {
						border = "none",
					},
					completion = {
						border = "none",
					},
				},
				-- config nvim cmp to work with snippet engine
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				-- autocompletion sources
				sources = cmp.config.sources({
					{ name = "lazydev" },
					{ name = "copilot", priority = 1100 }, -- GitHub Copilot with highest priority
					{ name = "luasnip", priority = 1000 }, -- snippets with higher priority
					{ name = "nvim_lsp", priority = 900 },
					{ name = "buffer", priority = 500 }, -- text within current buffer
					{ name = "path", priority = 250 }, -- file system paths
				}),

				mapping = cmp.mapping.preset.insert({
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<C-d>"] = cmp.mapping(function()
						cmp.close_docs()
					end, { "i", "s" }),

					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-j>"] = cmp.mapping(select_next_item),
					["<C-k>"] = cmp.mapping(select_prev_item),
					["<C-n>"] = cmp.mapping(select_next_item),
					["<C-p>"] = cmp.mapping(select_prev_item),
					["<Down>"] = cmp.mapping(select_next_item),
					["<Up>"] = cmp.mapping(select_prev_item),

					["<C-y>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							confirm(entry)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							confirm(entry)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				-- setup lspkind for vscode pictograms in autocompletion dropdown menu
				formatting = {
					format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
				},
			})
			local config = require("cmp.config")
			local toggle_ghost_text = function()
				if vim.api.nvim_get_mode().mode ~= "i" then
					return
				end

				local cursor_column = vim.fn.col(".")
				local current_line_contents = vim.fn.getline(".")
				local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)

				local should_enable_ghost_text = character_after_cursor == ""
					or vim.fn.match(character_after_cursor, [[\k]]) == -1

				local current = config.get().experimental.ghost_text
				if current ~= should_enable_ghost_text then
					config.set_global({
						experimental = {
							ghost_text = should_enable_ghost_text,
						},
					})
				end
			end

			vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
				callback = toggle_ghost_text,
			})
			-- ! Ghost text stuff ! --
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_lua").load({
				paths = "~/.config/nvim/lua/bitrift/plugins/snippets/",
			})
		end,
	},
}
