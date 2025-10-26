return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"moyiz/blink-emoji.nvim",
			"ray-x/cmp-sql",
			"L3MON4D3/LuaSnip",
			"zbirenbaum/copilot.lua",
			"echasnovski/mini.pairs",
			"giuxtaposition/blink-cmp-copilot",
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = { preset = "luasnip" },
			keymap = {
				preset = "default",
				["<C-p>"] = { "select_prev" },
				["<C-n>"] = { "select_next" },
				["<Tab>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-f>"] = { "snippet_forward" },
				["<C-b>"] = { "snippet_backward" },
			},
			appearance = {
				nerd_font_variant = "normal",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
						treesitter = { "lsp" },
					},
				},
				ghost_text = { enabled = true },
			},
			signature = { enabled = false },
			cmdline = {
				keymap = { preset = "inherit" },
				completion = {
					menu = { auto_show = true },
					list = {
						selection = {
							preselect = false,
							auto_insert = false,
						},
					},
				},
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "emoji", "sql", "copilot" },
				providers = {
					lsp = {
						score_offset = 100, -- Highest priority
						max_items = 3, -- Limit LSP suggestions to 5
					},
					path = {
						score_offset = 50, -- Second priority
					},
					snippets = {
						score_offset = -10, -- Lower priority
					},
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						async = true,
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},
					sql = {
						-- IMPORTANT: use the same name as you would for nvim-cmp
						name = "sql",
						module = "blink.compat.source",

						-- all blink.cmp source config options work as normal:
						score_offset = -3,

						-- this table is passed directly to the proxied completion source
						-- as the `option` field in nvim-cmp's source config
						--
						-- this is NOT the same as the opts in a plugin's lazy.nvim spec
						opts = {},
						should_show_items = function()
							return vim.tbl_contains(
								-- Enable emoji completion only for git commits and markdown.
								-- By default, enabled for all file-types.
								{ "sql" },
								vim.o.filetype
							)
						end,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
		config = function(_, opts)
			require("blink.cmp").setup(opts)

			vim.keymap.set("i", "<CR>", function()
				local blink = require("blink.cmp")
				if blink.is_visible() and blink.get_selected_item() then
					return blink.accept()
				else
					return vim.api.nvim_replace_termcodes(require("mini.pairs").cr(), true, true, true)
				end
			end, { expr = true, noremap = true })
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("bitrift.plugins.snippets.luasnip")
		end,
	},
}
