return {
	{ "nvim-telescope/telescope-fzf-native.nvim", event = "VeryLazy", build = "make" },
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {},
	},
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		config = function()
			require("mini.pairs").setup({})
		end,
	},

	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- { "folke/snacks.nvim" },
		},
		config = function()
			vim.g.opencode_opts = {
				provider = {
					enabled = "tmux",
					tmux = {
						options = "-h",
					},
					-- snacks = {
					-- 	win = {
					-- 		enter = true,
					-- 	},
					-- 	env = {
					-- 		OPENCODE_THEME = "system",
					-- 	},
					-- },
				},
			}

			-- Required for `opts.auto_reload`
			vim.opt.autoread = true

			-- Smart toggle: focus if exists, create if not, close if focused
			local function smart_opencode_toggle()
				-- Get current pane ID
				local current_pane = vim.fn.system("tmux display-message -p '#{pane_id}'"):gsub("\n", "")

				-- Find opencode pane
				local find_cmd =
					"tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep 'opencode' | awk '{print $1}'"
				local opencode_pane = vim.fn.system(find_cmd):gsub("\n", "")

				if opencode_pane ~= "" then
					-- Opencode pane exists
					if current_pane == opencode_pane then
						-- Currently in opencode pane, close it
						require("opencode").toggle()
					else
						-- Focus the existing opencode pane
						vim.fn.system("tmux select-pane -t " .. opencode_pane)
					end
				else
					-- No opencode pane, create it
					require("opencode").toggle()
				end
			end

			-- Recommended/example keymaps
			vim.keymap.set("n", "<C-P>", smart_opencode_toggle, { desc = "opencode: Smart toggle" })
			vim.keymap.set({ "n", "x" }, "<C-N>", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask about this" })
			vim.keymap.set("v", "<leader>oa", function()
				require("opencode").ask("@selection: ")
			end, { desc = "opencode: Ask about selection" })
		end,
	},
	--
	-- {
	-- 	"coder/claudecode.nvim",
	-- 	dependencies = { "folke/snacks.nvim" },
	-- 	config = true,
	-- 	keys = {
	-- 		{ "<leader>ot", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude embedded" },
	-- 		{ "<leader>oa", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
	-- 		{ "<leader>oA", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
	-- 	},
	-- },
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = { "nvim-neo-tree/neo-tree.nvim" },
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"junegunn/fzf",
		event = "VeryLazy",
		build = ":call fzf#install()",
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufEnter",
		config = function()
			require("treesitter-context").setup({
				max_lines = 5,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = false,
			})

			-- Toggle the Trouble window
			vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle()
			end, { desc = "Trouble: Toggle the Trouble window" })

			-- Navigate to the next item in Trouble
			vim.keymap.set("n", "[t", function()
				require("trouble").next({ skip_groups = true, jump = true })
			end, { desc = "Trouble: Go to next item (skip groups)" })

			-- Navigate to the previous item in Trouble
			vim.keymap.set("n", "]t", function()
				require("trouble").previous({ skip_groups = true, jump = true })
			end, { desc = "Trouble: Go to previous item (skip groups)" })
		end,
	},
	{
		"theprimeagen/vim-be-good",

		config = function() end,
	},
	{
		"tpope/vim-surround",
	},
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				filetype = { "markdown", "conf" },
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		opts = {
			workspaces = {
				{
					name = "Study",
					path = "~/Documents/obsidian/My-study/",
				},
			},
			-- Disable UI to avoid conflict with render-markdown
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = "VeryLazy",
		opts = {},
		ft = { "markdown", "codecompanion" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
	},

	{
		-- markdown preview from nvim
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
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
	},
	-- {
	-- 	"okuuva/auto-save.nvim",
	-- 	version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged relea
	-- 	cmd = "ASToggle", -- optional for lazy loading on command
	-- 	event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
	-- 	opts = {
	-- 		enabled = true,
	-- 		noautocmd = true,
	-- 		message = function()
	-- 			return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
	-- 		end,
	-- 		dim = 0.18,
	-- 		cleaning_interval = 1250,
	-- 	},
	-- 	noautocmd = false,
	-- 	debounce_delay = 2000,
	-- },
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{
		"windwp/nvim-ts-autotag",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-ts-autotag").setup({})
		end,
		lazy = true,
		event = "VeryLazy",
	},
	{

		"laytan/cloak.nvim",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
				highlight_group = "Comment",
				patterns = {
					{
						-- Match any file starting with ".env".
						-- This can be a table to match multiple file patterns.
						file_pattern = {
							".env*",
							"wrangler.toml",
							".dev.vars",
						},
						-- Match an equals sign and any character after it.
						-- This can also be a table of patterns to cloak,
						-- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
						cloak_pattern = "=.+",
					},
				},
			})
		end,
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = false,
				},
			},
		},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate Left" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate Down" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate Up" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate Right" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate Previous" },
		},
	},
	{
		"Aasim-A/scrollEOF.nvim",
		event = "VeryLazy",
		config = function()
			require("scrollEOF").setup()
		end,
	},
	{
		"tpope/vim-dadbod",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},

		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		"Nvchad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
	},
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		keys = {
			{
				"<leader>rn",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "Incremental rename",
				mode = "n",
				noremap = true,
				expr = true,
			},
		},
		config = true,
	},
}
