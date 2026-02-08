return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master", -- Use latest version instead of old tag
    dependencies = {
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
      telescope.load_extension("noice")
      local keymap = vim.keymap.set
      keymap("n", "<leader>gt", ":Telescope git_branches <CR>", { desc = "Telescope: Git branches" })
    end,
  },
}
