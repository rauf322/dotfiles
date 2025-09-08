return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		routes = {
			-- Filter out save/edit noise messages
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
						{ find = "%d fewer lines" },
						{ find = "%d more lines" },
					},
				},
				opts = { skip = true },
			},
			-- Filter out ESLint parsing errors
			{
				filter = {
					event = "notify",
					find = "ESLint output parsing failed",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			},
		},
		presets = {
			lsp_doc_border = true,
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			config = function()
				-- Ensure the background highlight group exists
				vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1a1a1a" })
				require("notify").setup({
					timeout = 200,
					stages = "fade_in_slide_out",
					background_colour = "NotifyBackground",
					render = "compact",
					top_down = false,
					-- max_width = function()
					-- 	return math.floor(vim.o.columns * 0.4)
					-- end,
					-- max_height = function()
					-- 	return math.floor(vim.o.lines * 0.2)
					-- end,
					-- minimum_width = 30,
					fps = 60,
					icons = {
						ERROR = "✗",
						WARN = "⚠",
						INFO = "ℹ",
						DEBUG = "🐛",
						TRACE = "➤",
					},
				})
			end,
		},
	},
}
