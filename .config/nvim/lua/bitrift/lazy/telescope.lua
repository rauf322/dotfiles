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

            keymap('n', '<leader>?', ":Telescope keymaps<CR>", { desc = "Telescope: Show Keymaps" })
            keymap('n', '<leader><Tab>', builtin.find_files, { desc = "Telescope: Find Files" })
            keymap('n', '<C-p>', builtin.git_files, { desc = "Telescope: Git Files" })

            keymap('n', '<leader>pws', function()
                builtin.grep_string({ search = vim.fn.expand("<cword>") })
            end, { desc = "Telescope: Grep Current Word" })

            keymap('n', '<leader>pWs', function()
                builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
            end, { desc = "Telescope: Grep Current WORD" })

            keymap('n', '<leader>ps', function()
                require('telescope.builtin').live_grep()
            end, { desc = "Telescope: Live Grep" })

            keymap('n', '<leader>vh', builtin.help_tags, { desc = "Telescope: Help Tags" })
            keymap('n', '<leader>gt', ":Telescope git_branches <CR>", { desc = "Telescope: Git branches" })
        end,
    },
}
