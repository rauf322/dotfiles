---@diagnostic disable-next-line: unused-local
local root_files = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "windwp/nvim-autopairs",
    },
    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities(),
            require("blink.cmp").get_lsp_capabilities()
        )

        require("fidget").setup({})

        -- General mason setup with tools
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })
        local npairs = require('nvim-autopairs')
        npairs.setup({
            check_ts = true,     -- Enable treesitter checking for more precise pair matching
            map_cr = true,       -- Map <CR> to auto-close pairs when pressing Enter
            map_complete = true, -- Enable completion for autopairs
        })
        require("mason-lspconfig").setup({
            -- Add automatic_installation field to avoid the error
            automatic_installation = true, -- This enables automatic installation of LSP servers

            ensure_installed = {
                "lua_ls",
                "ts_ls",
                "eslint",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                    vim.keymap.set("n", "Z", vim.lsp.buf.hover,
                        { desc = "Show hover information for symbol under cursor" })

                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
                        { desc = "Show available code actions (e.g., quick fixes, refactoring)" })
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostic = {
                                    global = { "vim" },
                                },
                                format = {
                                    enable = true,
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    },
                                },
                            },
                        },
                    })
                end,
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier",
                "eslint_d",
                "black",
                "eslint-lsp",
                "js-debug-adapter",
                "typescript-language-server",
                "pylint",
                "htmlhint"
            },
        })
        vim.diagnostic.config({
            virtual_text = true,    -- Show inline error highlights
            signs = true,           -- Show icons in the gutter for errors/warnings
            underline = true,       -- Underline errors and warnings in the code
            float = {
                focusable = false,  -- Optional: whether the floating window is focusable
                style = "minimal",  -- You can change this to 'default' or 'classic' for a richer UI
                border = "rounded", -- Border style of the floating window
                source = "always",  -- Show the source of the diagnostic
                header = "",        -- Optional: You can provide a header for the floating window
                prefix = "",        -- Optional: Prefix for the message
                max_width = 80,     -- Max width of the floating window (adjust as needed)
            },
        })
    end,
}
