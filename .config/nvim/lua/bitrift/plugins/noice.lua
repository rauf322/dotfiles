return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			config = function()
				require("notify").setup({
					timeout = 1000, -- 1 second timeout for all notifications
					stages = "fade_in_slide_out",
					background_colour = "FloatShadow",
					icons = {
						ERROR = "",
						WARN = "",
						INFO = "",
						DEBUG = "",
						TRACE = "✎",
					},
				})
			end,
		},
	},
	config = function()
		require("noice").setup({
			-- Command line popup instead of bottom cmdline
			cmdline = {
				enabled = true,
				view = "cmdline_popup", -- Use popup instead of cmdline
				opts = {
					position = {
						row = "50%",
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					},
				},
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
				},
			},
			
			-- Messages popup
			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},
			
			-- Popup menu for completions
			popupmenu = {
				enabled = true,
				backend = "nui", -- Use nui for popup menu
				kind_icons = {},
			},
			
			-- LSP progress and hover docs
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = {
					enabled = true,
				},
				signature = {
					enabled = true,
				},
				progress = {
					enabled = true,
				},
			},
			
			-- Notification settings
			notify = {
				enabled = true,
				view = "notify",
			},
			
			-- Views configuration for timeout
			views = {
				cmdline_popup = {
					position = {
						row = "50%",
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					},
				},
				notify = {
					backend = "notify",
					fallback = "mini",
					format = "notify",
					replace = false,
					merge = false,
					timeout = 1000, -- 1 second timeout
				},
				mini = {
					backend = "mini",
					timeout = 1000, -- 1 second timeout
				},
			},
			
			-- Routes for different message types
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
			},
			
			-- Presets for common configurations
			presets = {
				bottom_search = false, -- Use classic bottom cmdline for search
				command_palette = true, -- Position the cmdline and popupmenu together
				long_message_to_split = true, -- Long messages will be sent to split
				inc_rename = false, -- Enables input dialog for inc-rename.nvim
				lsp_doc_border = true, -- Add border to hover docs and signature help
			},
		})
	end,
}