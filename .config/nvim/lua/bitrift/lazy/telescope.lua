return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({
                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown({})
                }
            })

            telescope.load_extension("ui-select")

            local keymap = vim.keymap.set
            keymap('n', '<leader><Tab>', builtin.find_files, {})
            keymap('n', '<C-p>', builtin.git_files, {})
            keymap('n', '<leader>pws', function()
                builtin.grep_string({ search = vim.fn.expand("<cword>") })
            end)
            keymap('n', '<leader>pWs', function()
                builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
            end)
            keymap('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
            keymap('n', '<leader>vh', builtin.help_tags, {})
        end,
    },
}

