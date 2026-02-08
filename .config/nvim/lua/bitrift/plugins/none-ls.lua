return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")

    -- Custom ESLint rule for JSX self-closing components
    local jsx_self_closing = {
      name = "jsx-self-closing",
      method = null_ls.methods.CODE_ACTION,
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      generator = {
        fn = function(params)
          local actions = {}

          -- Find JSX opening/closing tag patterns
          local content = table.concat(params.content, "\n")
          local line = params.content[params.row] or ""

          -- Pattern to match <Component></Component> (empty tags)
          local jsx_pattern = "<([A-Z][%w]*)></[A-Z][%w]*>"
          local match = line:match(jsx_pattern)

          if match then
            table.insert(actions, {
              title = "Convert to self-closing JSX tag",
              action = function()
                local new_line = line:gsub(jsx_pattern, "<%1 />")
                vim.api.nvim_buf_set_lines(0, params.row - 1, params.row, false, { new_line })
              end,
            })
          end

          return actions
        end,
      },
    }

    null_ls.setup({
      sources = {
        -- Custom JSX self-closing action
        jsx_self_closing,

        -- Prettier for formatting (optional, since you have conform.nvim)
        null_ls.builtins.formatting.prettier.with({
          condition = function(utils)
            return utils.root_has_file({ "package.json" })
          end,
          extra_args = {
            "--single-quote",
            "--jsx-single-quote",
            "--jsx-bracket-same-line=false",
          },
        }),
      },

      -- Configure to work alongside existing LSP servers
      on_attach = function(client, bufnr)
        -- Disable formatting if you want to use conform.nvim instead
        if client.name == "null-ls" then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end,
    })
  end,
}
