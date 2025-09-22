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
			"zbirenbaum/copilot.lua",
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				["<C-p>"] = { "select_prev" },
				["<C-n>"] = { "select_next" },
				["<CR>"] = { "accept", "fallback" },
				["<C-Space>"] = { "show" },
				["<C-f>"] = { "snippet_forward" },
				["<C-b>"] = { "snippet_backward" },
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},
			appearance = {
				nerd_font_variant = "normal",
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
					update_delay_ms = 50,
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
			signature = { enabled = true },
			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "emoji", "sql", "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = -100,
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
