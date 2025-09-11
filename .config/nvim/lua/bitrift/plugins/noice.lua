return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		routes = {
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
			-- Filter out Neo-tree hidden files toggle messages
			{
				filter = {
					event = "notify",
					find = "Neo%-tree.*Toggling hidden files",
				},
				opts = { skip = true },
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = true,
		},
		views = {
			cmdline_popup = {
				position = {
					row = 5,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
			},
			popupmenu = {
				relative = "editor",
				position = {
					row = 8,
					col = "50%",
				},
				size = {
					width = 60,
					height = 10,
				},
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
				win_options = {
					winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
				},
			},
			hover = {
				border = { style = "rounded" },
				size = { max_width = 50, max_height = 5 },
				position = { row = 2, col = 2 },
			},
			mini = {
				size = { max_width = 80, max_height = 15 },
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",

			config = function()
				vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#1a1a1a" })
				require("notify").setup({
					timeout = 200,
					background_colour = "#0000",
				})
			end,
		},
	},
}
