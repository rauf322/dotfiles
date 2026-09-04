require("lspsaga").setup({
  ui = {
    border = "rounded",
    code_action = "",
  },
  lightbulb = {
    enable = false,
    sign = false,
  },
  symbol_in_winbar = {
    enable = false,
  },
  code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = true,
  },
  finder = {
    max_height = 0.6,
    left_width = 0.4,
    right_width = 0.6,
    methods = {},
    default = "def+ref+imp",
  },
  definition = {
    width = 0.6,
    height = 0.5,
    keys = {
      edit = "<CR>",
      vsplit = "v",
      split = "s",
      quit = "q",
    },
  },
  rename = {
    in_select = false,
  },
  hover = {
    max_width = 0.8,
    max_height = 0.8,
    open_link = "gl",
  },
})

local keymap = vim.keymap.set

keymap("n", "K", function()
  require("pretty_hover").hover()
end, { desc = "Show hover documentation", silent = true })

keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "LSP finder (refs/def/impl)", silent = true })
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition", silent = true })
keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition", silent = true })
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action", silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename symbol", silent = true })
keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous diagnostic", silent = true })
keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next diagnostic", silent = true })
keymap("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Show line diagnostics", silent = true })
keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Toggle outline", silent = true })
