local M = {}

-- M.base46 = {
-- 	theme = "kanagawa",
-- 	transparency = false,
-- }
M.ui = {
	tabufline = {
		enabled = false,
	},
	statusline = { theme = "default", separator_style = "arrow" },
	telescope = { style = "borderless" }, -- borderless / bordered
	nvdash = {
		load_on_startup = true,
		header = {
			"                            ",
			"     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
			"   ▄▀███▄     ▄██ █████▀    ",
			"   ██▄▀███▄   ███           ",
			"   ███  ▀███▄ ███           ",
			"   ███    ▀██ ███           ",
			"   ███      ▀ ███           ",
			"   ▀██ █████▄▀█▀▄██████▄    ",
			"     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
			"                            ",
			"     Powered By  eovim    ",
			"                            ",
		},

		buttons = {
			{ txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
			{ txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
		},
	},
}
M.lsp = {
	signature = true,
}

return M
