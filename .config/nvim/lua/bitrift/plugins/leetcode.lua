return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim", -- Use your existing Telescope
	},
	opts = {
		-- Language to use for solutions
		lang = "typescript", -- Change to your preference: "python3", "typescript", "cpp", etc.

		-- Storage directories
		storage = {
			home = vim.fn.expand("~/leetcode"),
			cache = vim.fn.expand("~/leetcode/.cache"),
		},

		-- Use Telescope as picker
		picker = {
			provider = "telescope",
		},

		-- Console settings (test results window)
		console = {
			open_on_runcode = true,
			dir = "row", -- Layout: "row" or "col"
			size = {
				width = "90%",
				height = "75%",
			},
			result = {
				size = "60%", -- Test results area
			},
			testcase = {
				virt_text = true, -- Show virtual text for test cases
				size = "40%", -- Test cases area
			},
		},

		-- Problem description panel
		description = {
			position = "left", -- "left" or "right"
			width = "40%",
			show_stats = true, -- Show difficulty, acceptance rate, etc.
		},

		-- Editor settings
		editor = {
			reset_previous_code = true, -- Reset code when opening new problem
			fold_imports = true, -- Auto-fold import statements
		},

		-- Keybindings within leetcode interface
		keys = {
			toggle = { "q" }, -- Close/toggle windows
			confirm = { "<CR>" }, -- Confirm selections
			reset_testcases = "r", -- Reset test cases
			use_testcase = "U", -- Use custom test case
			focus_testcases = "H", -- Focus test cases pane
			focus_result = "L", -- Focus results pane
		},

		-- Enable status notifications
		logging = true,

		-- Hooks for custom functionality
		hooks = {
			-- Run when entering leetcode
			["enter"] = {},
			-- Run when opening a question
			["question_enter"] = {},
			-- Run when leaving leetcode
			["leave"] = {},
		},
	},
}
