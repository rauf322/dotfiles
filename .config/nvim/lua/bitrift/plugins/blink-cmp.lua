return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "moyiz/blink-emoji.nvim",
      "ray-x/cmp-sql",
      "fang2hou/blink-copilot",
      "supermaven-inc/supermaven-nvim",
      "echasnovski/mini.pairs",
    },
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "luasnip" },
      keymap = {
        preset = "default",
        ["<C-p>"] = { "select_prev" },
        ["<C-n>"] = { "select_next" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-f>"] = { "snippet_forward" },
        ["<C-b>"] = { "snippet_backward" },
      },
      appearance = {
        nerd_font_variant = "normal",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
          },
        },

        menu = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
        ghost_text = { enabled = true },
      },
      signature = { enabled = false },
      cmdline = {
        keymap = { preset = "inherit" },
        completion = {
          menu = { auto_show = true },
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji", "sql", "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            async = true,
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            opts = { insert = true }, -- Insert emoji (default) or complete its name
            should_show_items = function()
              return vim.tbl_contains(
                -- Enable emoji completion only for git commits and markdown.
                { "gitcommit", "markdown" },
                vim.o.filetype
              )
            end,
          },
          sql = {
            -- IMPORTANT: use the same name as you would for nvim-cmp
            name = "sql",
            module = "blink.compat.source",
            opts = {},
            should_show_items = function()
              return vim.tbl_contains(
                -- Enable SQL completion only for sql files.
                { "sql" },
                vim.o.filetype
              )
            end,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
