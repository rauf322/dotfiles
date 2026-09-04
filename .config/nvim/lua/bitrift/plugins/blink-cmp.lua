require("blink.compat").setup({})

require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<Tab>",
    clear_suggestion = "<C-e>",
    accept_word = "<C-w>",
  },
})

require("blink.cmp").setup({
  snippets = { preset = "luasnip" },
  keymap = {
    preset = "default",
    ["<C-p>"] = { "select_prev" },
    ["<C-n>"] = { "select_next" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-f>"] = { "snippet_forward" },
    ["<C-b>"] = { "snippet_backward" },
  },
  appearance = {
    nerd_font_variant = "mono",
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
      max_height = 10,
      winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
        components = {
          source_name = {
            text = function(ctx)
              return "[" .. ctx.source_name .. "]"
            end,
            highlight = "CmpItemMenu",
          },
        },
      },
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
    default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },
    providers = {
      emoji = {
        module = "blink-emoji",
        name = "Emoji",
        opts = { insert = true },
        should_show_items = function()
          return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
        end,
      },
      sql = {
        name = "sql",
        module = "blink.compat.source",
        opts = {},
        should_show_items = function()
          return vim.tbl_contains({ "sql" }, vim.o.filetype)
        end,
      },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
