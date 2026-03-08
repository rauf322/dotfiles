return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescriptreact = { "prettierd" },
          svelte = { "prettierd" },
          css = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          jsonc = { "prettierd" },
          yaml = { "prettierd" },
          markdown = { "prettierd" },
          graphql = { "prettierd" },
          liquid = { "prettierd" },
          lua = { "stylua" },
          python = { "isort", "black" },
          go = { "goimports", "gofumpt" },
          rust = { "rustfmt" },
        },
        formatters = {
          -- prettier = {
          -- 	args = {
          -- 		"--stdin-filepath",
          -- 		"$FILENAME",
          -- 		"--single-quote",
          -- 		"--jsx-single-quote",
          -- 		-- "--print-width=140",
          -- 	},
          -- },
          stylua = {
            args = {
              -- "--column-width=140",
              "--stdin-filepath",
              "$FILENAME",
              "-",
            },
          },
        },
        format_on_save = {
          async = false,
          lsp_fallback = false,
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>s", function()
        -- Wrap the whole operation and capture any error message
        local ok, err = pcall(function()
          -- require the jsx-autofix safely
          local ok_req, jsx_autofix = pcall(require, "bitrift.utils.jsx-autofix")
          if ok_req and jsx_autofix and type(jsx_autofix.fix_jsx_self_closing) == "function" then
            -- run the JSX fixer, but protect it as well
            local ok_fix, fix_err = pcall(jsx_autofix.fix_jsx_self_closing)
            if not ok_fix then
              vim.notify("JSX autofix failed: " .. tostring(fix_err), vim.log.levels.WARN)
            end
          end

          -- small wait to let LSP / buffer updates settle
          vim.wait(10)

          -- Format with conform, but check that conform exists and has format
          if type(conform) == "table" and type(conform.format) == "function" then
            local ok_fmt, fmt_err = pcall(function()
              conform.format({
                lsp_fallback = true,
                async = false,
                quiet = true,
              })
            end)
            if not ok_fmt then
              vim.notify("Formatting failed: " .. tostring(fmt_err) .. ". Saving without formatting.", vim.log.levels.WARN)
            end
          else
            vim.notify("conform.format not available; saving without formatting", vim.log.levels.WARN)
          end

          -- Wait a bit to let formatting complete if any
          vim.wait(50)

          -- Save all changed buffers
          vim.cmd("wa")
        end)

        if not ok then
          -- show the actual error so you can debug why pcall failed
          vim.notify("Format and save operation failed: " .. tostring(err), vim.log.levels.ERROR)
        end
      end, { desc = "Format file(s) and save" })
    end,
  },
}
