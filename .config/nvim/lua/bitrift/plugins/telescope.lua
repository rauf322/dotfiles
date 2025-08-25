return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local action = require("telescope.actions")
			local builtin = require("telescope.builtin")
			-- Configure file and directory exclusions
			telescope.load_extension("fzf")
			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"%.git/", -- Ignore .git directory
						"%.git\\", -- Windows support
						"node_modules/", -- Ignore node_modules directory
						"node_modules\\", -- Windows support
						"dist/", -- Common build directory
						"build/", -- Common build directory
						"%.o", -- Object files
						"%.a", -- Static libraries
						"%.out", -- Output files
						"%.class", -- Java class files
						"%.pdf", -- PDF files
						"%.zip", -- Archive files
						"%.iso", -- ISO files
						"%.tar", -- Archive files
						"%.gz", -- Compressed files
						"%.rar", -- Compressed files
						"%.7z", -- Compressed files
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden", -- Search hidden files
						"--glob=!.git/", -- Exclude .git directory
						"--glob=!node_modules/", -- Exclude node_modules directory
					},
				},
				pickers = {
					find_files = {
						hidden = true, -- This will include hidden files like .config
					},
					git_files = {
						hidden = true, -- Also include hidden files in git_files
						show_untracked = true,
					},
				},
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})
			telescope.load_extension("ui-select")
			local keymap = vim.keymap.set
			keymap("n", "<leader>?", ":Telescope keymaps<CR>", { desc = "Telescope: Show Keymaps" })
			keymap("n", "<leader><Tab>", builtin.find_files, { desc = "Telescope: Find Files" })
			keymap("n", "<C-p>", builtin.git_files, { desc = "Telescope: Git Files" })
			keymap("n", "<leader>pws", function()
				builtin.grep_string({ search = vim.fn.expand("<cword>") })
			end, { desc = "Telescope: Grep Current Word" })
			keymap("n", "<leader>pWs", function()
				builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
			end, { desc = "Telescope: Grep Current WORD" })
			keymap("n", "<leader>ps", function()
				require("telescope.builtin").live_grep()
			end, { desc = "Telescope: Live Grep" })
			keymap("n", "<leader>vh", builtin.help_tags, { desc = "Telescope: Help Tags" })
			keymap("n", "<leader>gt", ":Telescope git_branches <CR>", { desc = "Telescope: Git branches" })
		end,
	},
}
