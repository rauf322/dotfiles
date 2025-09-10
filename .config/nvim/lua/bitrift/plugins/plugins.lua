return {
	{ "nvim-telescope/telescope-fzf-native.nvim", event = "VeryLazy", build = "make" },
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate")
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
		"mbbill/undotree",

		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo: Toggle undotree" })
		end,
	},
	{
		"theprimeagen/vim-be-good",

		dependencies = {
			"nvim-lua/plenary.nvim",
		},

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
		"nvim-neo-tree/neo-tree.nvim",
		event = "VeryLazy",
		branch = "v3.x",
		cmd = { "Neotree" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			-- Disable netrw (same as nvim-tree)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("neo-tree").setup({
				close_if_last_window = true,
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,

				-- Window configuration matching nvim-tree
				window = {
					position = "right",
					width = 30,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						-- Custom clipboard copy (C key)
						["C"] = function(state)
							local node = state.tree:get_node()
							if not node then
								print("No item selected!")
								return
							end

							local path = vim.fn.expand(node.path)
							path = path:gsub('"', '\\"')

							local applescript_cmd =
								string.format('osascript -e "set the clipboard to POSIX file \\"%s\\""', path)
							local result = os.execute(applescript_cmd)

							if result == 0 then
								local item_type = node.type == "directory" and "folder" or "file"
								print("Copied " .. item_type .. " to system clipboard: " .. path)
							else
								print("Failed to copy to clipboard")
							end
						end,

						-- Delete to trash (D key)
						["D"] = function(state)
							local inputs = require("neo-tree.ui.inputs")
							local node = state.tree:get_node()
							if node.type == "message" then
								return
							end
							local msg = "Are you sure you want to delete " .. node.name .. " to trash?"
							inputs.confirm(msg, function(confirmed)
								if not confirmed then
									return
								end

								-- Use trash command on macOS
								local trash_cmd = "trash " .. vim.fn.shellescape(node.path)
								local result = vim.fn.system(trash_cmd)
								if vim.v.shell_error == 0 then
									print("Moved to trash: " .. node.name)
									require("neo-tree.sources.manager").refresh("filesystem")
								else
									print("Failed to move to trash: " .. result)
								end
							end)
						end,

						-- Normal delete (d key) - keep default behavior
						-- ["d"] uses neo-tree's default delete

						-- Smart Enter key behavior (same as nvim-tree)
						["<CR>"] = function(state)
							local node = state.tree:get_node()
							if node.type == "directory" then
								if node:is_expanded() then
									require("neo-tree.sources.filesystem").toggle_directory(state, node)
								else
									require("neo-tree.sources.filesystem").toggle_directory(state, node)
								end
							else
								-- Open file logic - find non-neo-tree window
								local current_win = vim.api.nvim_get_current_win()
								local win_ids = vim.api.nvim_tabpage_list_wins(0)
								local target_win = current_win

								for _, win in ipairs(win_ids) do
									local buf = vim.api.nvim_win_get_buf(win)
									local filetype = vim.bo[buf].filetype
									if vim.api.nvim_win_get_config(win).relative == "" and filetype ~= "neo-tree" then
										target_win = win
										break
									end
								end

								if target_win ~= current_win then
									vim.api.nvim_set_current_win(target_win)
								end

								require("neo-tree.sources.filesystem.commands").open(state)
								-- Close neo-tree after opening file
								require("neo-tree.command").execute({ action = "close" })
							end
						end,
					},
				},

				filesystem = {
					-- Follow current file (same as nvim-tree update_focused_file)
					follow_current_file = {
						enabled = true,
						leave_dirs_open = true,
					},
					-- Show hidden files by default (matches nvim-tree filters.dotfiles = true)
					filtered_items = {
						visible = false, -- Hidden by default
						hide_dotfiles = true,
						hide_gitignored = true,
						hide_hidden = true,
					},
					-- Auto-refresh on write
					use_libuv_file_watcher = true,
				},

				-- Enable file operations for LSP
				event_handlers = {
					{
						event = "file_opened",
						handler = function()
							-- Close neo-tree when file is opened (quit_on_open behavior)
							require("neo-tree.command").execute({ action = "close" })
						end,
					},
				},
			})

			-- Global keymaps (same as nvim-tree)
			local keymap = vim.keymap
			keymap.set("n", "<leader>ef", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
			keymap.set("n", "<leader>ff", function()
				-- Smart behavior: close if in neo-tree, reveal if outside
				if vim.bo.filetype == "neo-tree" then
					vim.cmd("Neotree close")
				else
					vim.cmd("Neotree reveal")
				end
			end, { desc = "Toggle file explorer on current file" })
			keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Close file explorer" })
			keymap.set("n", "<leader>er", "<cmd>Neotree filesystem refresh<CR>", { desc = "Refresh file explorer" })
			keymap.set("n", "<M-Tab>", "<C-^>", { desc = "Toggle last buffer" })

			-- Window equalization (same as nvim-tree)
			keymap.set("n", "<leader>we", function()
				-- Find neo-tree window and resize
				local neo_tree_wins = vim.tbl_filter(function(win)
					local buf = vim.api.nvim_win_get_buf(win)
					return vim.bo[buf].filetype == "neo-tree"
				end, vim.api.nvim_tabpage_list_wins(0))

				if #neo_tree_wins > 0 then
					vim.api.nvim_win_set_width(neo_tree_wins[1], 30)
				end
				vim.cmd("wincmd =")
			end, { desc = "Equalize all windows" })
		end,
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "Study",
					path = "~/Documents/obsidian/My-study/",
				},
			},
			-- Disable UI to avoid conflict with render-markdown
			ui = {
				enable = false,
			},
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
	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local autopairs = require("nvim-autopairs") -- import nvim-autopairs

			-- setup autopairs
			autopairs.setup({
				check_ts = true, -- treesitter enabled
				ts_config = {
					lua = { "string" }, -- dont add pairs in lua string treesitter nodes
					javascript = { "template_string" }, -- dont add pairs in javscript template_string treesitter nodes
					java = false, -- dont check treesitter on java
				},
			})
			-- import nvim-autopairs completion functionality
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			-- import nvim-cmp plugin (completions plugin)
			local cmp = require("cmp")
			-- make autopairs and completion work together
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"okuuva/auto-save.nvim",
		version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged relea
		cmd = "ASToggle", -- optional for lazy loading on command
		event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
		opts = {
			enabled = true,
			noautocmd = true,
			message = function()
				return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
			end,
			dim = 0.18,
			cleaning_interval = 1250,
		},
		noautocmd = false,
		debounce_delay = 2000,
	},
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
}
