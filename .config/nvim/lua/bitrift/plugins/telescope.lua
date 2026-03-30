local telescope = require("telescope")

telescope.load_extension("fzf")
telescope.setup({
  defaults = {
    file_ignore_patterns = {
      "%.git/",
      "%.git\\",
      "node_modules/",
      "node_modules\\",
      "dist/",
      "build/",
      "%.o",
      "%.a",
      "%.out",
      "%.class",
      "%.pdf",
      "%.zip",
      "%.iso",
      "%.tar",
      "%.gz",
      "%.rar",
      "%.7z",
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
      "--glob=!node_modules/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    git_files = {
      hidden = true,
      show_untracked = true,
    },
  },
  extensions = {},
})
telescope.load_extension("noice")

vim.keymap.set("n", "<leader>gt", ":Telescope git_branches <CR>", { desc = "Telescope: Git branches" })
