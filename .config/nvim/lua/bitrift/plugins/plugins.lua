require("quicker").setup({})

require("mini.pairs").setup({})

require("tsc").setup({})

require("lsp-file-operations").setup()

require("trouble").setup({
  icons = false,
})

vim.keymap.set("n", "<leader>tt", function()
  require("trouble").toggle()
end, { desc = "Trouble: Toggle the Trouble window" })
vim.keymap.set("n", "[t", function()
  require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Trouble: Go to next item (skip groups)" })
vim.keymap.set("n", "]t", function()
  require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "Trouble: Go to previous item (skip groups)" })

require("todo-comments").setup({})

require("flash").setup({
  modes = {
    search = {
      enabled = false,
    },
  },
})

vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })

require("scrollEOF").setup()

vim.g.db_ui_use_nerd_fonts = 1

require("colorizer").setup({
  options = {
    parsers = {
      tailwind = { enable = true },
    },
  },
})

require("pretty_hover").setup({
  border = "rounded",
  toggle = false,
})

require("cloak").setup({
  enabled = true,
  cloak_character = "*",
  highlight_group = "Comment",
  patterns = {
    {
      file_pattern = {
        ".env*",
        "wrangler.toml",
        ".dev.vars",
      },
      cloak_pattern = "=.+",
    },
  },
})

require("obsidian").setup({
  workspaces = {
    {
      name = "Study",
      path = "~/Documents/obsidian/My-study/",
    },
  },
})

require("render-markdown").setup({
  code = {
    sign = false,
  },
})

require("package-info").setup({
  autostart = true,
  hide_up_to_date = true,
})

vim.keymap.set("n", "<leader>ns", function()
  require("package-info").show()
end, { desc = "Package: Show versions" })
vim.keymap.set("n", "<leader>nu", function()
  require("package-info").update()
end, { desc = "Package: Update dependency" })
vim.keymap.set("n", "<leader>nd", function()
  require("package-info").delete()
end, { desc = "Package: Delete dependency" })
vim.keymap.set("n", "<leader>ni", function()
  require("package-info").install()
end, { desc = "Package: Install dependency" })
vim.keymap.set("n", "<leader>np", function()
  require("package-info").change_version()
end, { desc = "Package: Change version" })
vim.keymap.set("n", "<leader>nt", function()
  require("package-info").toggle()
end, { desc = "Package: Toggle versions" })
