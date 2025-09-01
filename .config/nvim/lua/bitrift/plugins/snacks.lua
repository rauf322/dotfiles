return {
	"folke/snacks.nvim",
	lazy = false, -- load at startup (so terminal keys are ready)
	priority = 1000, -- before other plugins that might rely on it
	opts = {
		-- enable Snacks' nicer input UI (same as you had inline)
		input = { enabled = true },
		indent = { enabled = true },
		dashboard = {
			preset = {
				pick = nil,
				---@type snacks.dashboard.Item[]
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = "󰒲 ",
						key = "l",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				header = [[
                                                                             
               ████ ██████           █████      ██                     
              ███████████             █████                             
              █████████ ███████████████████ ███   ███████████   
             █████████  ███    █████████████ █████ ██████████████   
            █████████ ██████████ █████████ █████ █████ ████ █████   
          ███████████ ███    ███ █████████ █████ █████ ████ █████  
         ██████  █████████████████████ ████ █████ █████ ████ ██████ 
      ]],
			},
			sections = {
				{ section = "header" },
				{
					section = "keys",
					indent = 1,
					padding = 1,
				},
				{ section = "recent_files", icon = " ", title = "Recent Files", indent = 3, padding = 2 },
				{ section = "startup" },
			},
		},
		terminal = {
			start_insert = false,
			auto_insert = false,
			auto_close = false,
			win = {
				style = "minimal",
			},
		},
	},

	config = function(_, opts)
		require("snacks").setup(opts)
		vim.keymap.set("n", "<leader>`", function()
			require("snacks.terminal").toggle()
		end, { desc = "Toggle terminal" })
		vim.keymap.set("n", "<leader>tg", function()
			require("snacks.terminal").toggle("lazygit")
		end, { desc = "Toggle lazygit" })
		vim.keymap.set("n", "<leader>th", function()
			require("snacks.terminal").toggle("btop")
		end, { desc = "Toggle htop" })

		vim.o.ttimeoutlen = 0
	end,
}
