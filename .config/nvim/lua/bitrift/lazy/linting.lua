return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            svelte = { "eslint_d" },       -- Requires eslint-plugin-svelte3
            css = { "stylelint" },         -- Use stylelint instead of eslint_d
            html = { "htmlhint" },         -- Use htmlhint instead of eslint_d
            json = {},                     -- No linter needed (Prettier handles formatting)
            yaml = { "yamllint" },         -- Optional: Add yamllint
            markdown = { "markdownlint" }, -- Optional: Add markdownlint
            graphql = {},                  -- ESLint can lint GraphQL with plugins
            liquid = {},                   -- Requires specific linter if needed
            python = { "pylint" },
        }

        -- Configure eslint_d with --fix for autofixing
        lint.linters.eslint_d = {
            cmd = "eslint_d",
            args = {
                "--fix",
                "--format",
                "json",
                "--stdin",
                "--stdin-filename",
                "%filepath",
            },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>lf", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}
