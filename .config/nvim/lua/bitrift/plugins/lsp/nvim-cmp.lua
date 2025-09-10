return {
	{
		"hrsh7th/nvim-cmp",
		branch = "main",
		dependencies = {
			"hrsh7th/cmp-buffer", -- source for text in buffer
			"hrsh7th/cmp-path", -- source for file system paths
			"hrsh7th/cmp-cmdline", -- source for command line
			"L3MON4D3/LuaSnip",
			"VonHeikemen/lsp-zero.nvim",
			"saadparwaiz1/cmp_luasnip", -- autocompletion
			"rafamadriz/friendly-snippets", -- snippets
			"nvim-treesitter/nvim-treesitter",
			"onsails/lspkind.nvim", -- vs-code pictograms
			"roobert/tailwindcss-colorizer-cmp.nvim",
		},

		config = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_action = require("lsp-zero").cmp_action()
			local luasnip = require("luasnip")
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

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			cmp.setup({
				experimental = {
					ghost_text = false,
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
					-- { name = "lazydev" },
					{ name = "nvim_lsp", priority = 900 },
					{ name = "buffer", priority = 500 }, -- text within current buffer
					{ name = "path", priority = 250 }, -- file system paths
					{ name = "luasnip", priority = 1000 }, -- snippets with higher priority
					{ name = "copilot", priority = 1100 }, -- GitHub Copilot with highest priority
				}),

				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<Tab>"] = cmp_action.luasnip_supertab(),
					["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
				}),
				-- setup lspkind for vscode pictograms in autocompletion dropdown menu
				formatting = {
					format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
				},
			})
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
