return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- Disable netrw (built-in file explorer)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Clean vertical separators
    vim.opt.fillchars:append("vert: ")

    -- Setup nvim-tree
    nvimtree.setup({
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false,
      },
      auto_reload_on_write = true,
      update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
      },
      view = {
        width = vim.o.columns,
        side = "left",
        adaptive_size = false,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
          },
        },
      },
      actions = {
        open_file = {
          quit_on_open = true,
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    })

    -- Autocommand to avoid linting nvim-tree buffers
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "NvimTree_*",
      callback = function()
        vim.b.no_lint = true
      end,
    })

    -- Keybindings
    local keymap = vim.keymap
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ff", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
    vim.keymap.set("n", "<M-Tab>", "<C-^>", { desc = "Toggle between last two buffers" })

    keymap.set("n", "<leader>we", function()
      require("nvim-tree.view").resize("30")
      vim.cmd("wincmd =")
    end, { desc = "Equalize all windows" })
  end,
}
