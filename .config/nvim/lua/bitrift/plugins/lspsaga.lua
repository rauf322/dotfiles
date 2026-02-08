return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    ui = {
      border = "rounded",
      code_action = "",
    },
    lightbulb = {
      enable = false, -- Disable lightbulb to avoid clutter
      sign = false,
    },
    symbol_in_winbar = {
      enable = false, -- Use lualine for breadcrumbs instead
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
      methods = {}, -- Auto-detect available methods
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
    hover = {
      max_width = 0.8,
      max_height = 0.8,
      open_link = "gl",
    },
  },
  config = function(_, opts)
    require("lspsaga").setup(opts)

    -- Keymaps for lspsaga
    local keymap = vim.keymap.set

    -- Hover documentation
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Show hover documentation", silent = true })

    -- Finder for references/definitions/implementations
    keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "LSP finder (refs/def/impl)", silent = true })

    -- Peek definition
    keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition", silent = true })

    -- Go to definition
    keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition", silent = true })

    -- Code action
    keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action", silent = true })

    -- Rename
    keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename symbol", silent = true })

    -- Diagnostic navigation
    keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous diagnostic", silent = true })
    keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next diagnostic", silent = true })

    -- Show line diagnostics
    keymap("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Show line diagnostics", silent = true })

    -- Outline
    keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Toggle outline", silent = true })
  end,
}
