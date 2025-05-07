return {
    {

        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { 'rafamadriz/friendly-snippets' },

        -- use a release tag to download pre-built binaries
        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                -- Disable the default preset to customize our keymaps
                preset = 'none',

                -- Map keys manually
                ['<C-p>'] = { 'select_prev', 'fallback' }, -- Default select previous item
                ['<C-n>'] = { 'select_next', 'fallback' }, -- Default select next item

                -- Disable <C-e> key from the preset
                ['<C-e>'] = {}, -- Hide menu

                -- Use <Tab> to accept the current suggestion
                ['<Tab>'] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.snippet_forward()   -- Jump to the next snippet placeholder
                        else
                            return cmp.select_and_accept() -- Select and accept the current completion
                        end
                    end,
                    'fallback' -- Fallback to the next mapping if necessary
                },

                -- Add any other custom key mappings here
                ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                nerd_font_variant = 'mono'
            },

            -- Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- Rust fuzzy matcher for typo resistance and better performance
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("luasnip.loaders.from_lua").load({
                paths = "~/.config/nvim/lua/bitrift/lazy/snippets",
            })
        end,
    }
}
