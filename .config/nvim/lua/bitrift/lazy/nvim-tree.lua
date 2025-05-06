return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvimtree = require("nvim-tree")
        vim.opt.fillchars:append("vert: ") -- removes the vertical separator line

        -- recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            view = {
                width = 30,
                side = "right",
            },
            -- change folder arrow icons
            renderer = {
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "", -- arrow when folder is closed
                            arrow_open = "", -- arrow when folder is open
                        },
                    },
                },
            },
            -- disable window_picker for
            -- explorer to work well with
            -- window splits
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
            -- custom keybinding for Enter to open file in current or leftmost window
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                -- Load default keybindings
                api.config.mappings.default_on_attach(bufnr)

                -- Custom override for <CR>
                vim.keymap.set("n", "<CR>", function()
                    local node = api.tree.get_node_under_cursor()
                    if node.nodes ~= nil then
                        api.node.open.edit()
                    else
                        local win_ids = vim.api.nvim_tabpage_list_wins(0)
                        local target_win = win_ids[1]
                        for _, win in ipairs(win_ids) do
                            if vim.api.nvim_win_get_config(win).relative == "" then
                                target_win = win
                                break
                            end
                        end
                        vim.api.nvim_set_current_win(target_win)
                        api.node.open.edit()
                    end
                end, { buffer = bufnr, noremap = true, silent = true })
            end

        })

        -- set keymaps
        local keymap = vim.keymap                                                                   -- for conciseness

        keymap.set("n", "<leader>ef", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
        keymap.set(
            "n",
            "<leader>ff",
            "<cmd>NvimTreeFindFileToggle<CR>",
            { desc = "Toggle file explorer on current file" }
        )                                                                                               -- toggle file explorer on current file
        keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
        keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })   -- refresh file explorer
        keymap.set("n", "<M-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
    end,
}
