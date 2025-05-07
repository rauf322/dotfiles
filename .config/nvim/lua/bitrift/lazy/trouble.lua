return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false,
            })

            -- Toggle the Trouble window
            vim.keymap.set("n", "<leader>tt", function()
                require("trouble").toggle()
            end, { desc = "Trouble: Toggle the Trouble window" })

            -- Navigate to the next item in Trouble
            vim.keymap.set("n", "[t", function()
                require("trouble").next({ skip_groups = true, jump = true })
            end, { desc = "Trouble: Go to next item (skip groups)" })

            -- Navigate to the previous item in Trouble
            vim.keymap.set("n", "]t", function()
                require("trouble").previous({ skip_groups = true, jump = true })
            end, { desc = "Trouble: Go to previous item (skip groups)" })
        end
    },
}
