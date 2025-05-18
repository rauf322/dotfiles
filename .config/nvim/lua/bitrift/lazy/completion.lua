return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
			},
			snippets = {
				preset = "luasnip",
			},

			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				menu = {
					border = "rounded",
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
				ghost_text = {
					enabled = true,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
			},

			signature = { enabled = true },

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.loaders.from_lua").load({
				paths = "~/.config/nvim/lua/bitrift/lazy/snippets/",
			})
		end,
	},
	-- {
	-- 	"github/copilot.vim",
	-- 	config = function()
	-- 		vim.g.copilot_no_tab_map = true
	-- 		function map(mode, lhs, rhs, opts)
	-- 			local options = { noremap = true }
	--
	-- 			if opts then
	-- 				options = vim.tbl_extend("force", options, opts)
	-- 			end
	--
	-- 			vim.api.nvim_set_keymap(mode, lhs, rhs, options)
	-- 		end
	-- 		map("i", "<C-g>", "copilot#Accept('<CR>')", { silent = true, expr = true })
	-- 	end,
	-- },
}
