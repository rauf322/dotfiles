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
			-- Filter out "no code action available" messages
			{
				filter = {
					event = "notify",
					find = "No code actions available",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "notify",
					find = "no code action available",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "notify",
					find = "No code action",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					find = "no code action",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					find = "No code action",
				},
				opts = { skip = true },
			},
			-- Filter out LSP sync errors during formatting
			{
				filter = {
					event = "msg_show",
					find = "attempt to get length of local 'prev_line'",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					find = "Error executing lua callback.*sync%.lua",
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
		messages = {
			enabled = true,
			view = "mini",
			view_error = "mini", -- view for errors
			view_warn = "mini", -- view for warnings
			view_history = "mini", -- view for :messages
			view_search = "mini", -- view for search count messages. Set to `false` to disable
		},
		notify = {
			-- Noice can be used as `vim.notify` so you can route any notification like other messages
			-- Notification messages have their level and other properties set.
			-- event is always "notify" and kind can be any log level as a string
			-- The default routes will forward notifications to nvim-notify
			-- Benefit of using Noice for this is the routing and consistent history view
			enabled = true,
			view = "mini",
		},
		lsp = {
			message = {
				-- Messages shown by lsp servers
				enabled = true,
				view = "mini",
			},
			views = {
				-- This sets the position for the search popup that shows up with / or with :
				cmdline_popup = {
					position = {
						row = "40%",
						col = "50%",
					},
				},
				mini = {
					-- timeout = 5000, -- timeout in milliseconds
					timeout = vim.g.neovim_mode == "skitty" and 2000 or 5000,
					align = "center",
					position = {
						-- Centers messages top to bottom
						row = "95%",
						-- Aligns messages to the far right
						col = "100%",
					},
				},
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
