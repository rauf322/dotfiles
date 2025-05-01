return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        config = function()
            local dap = require("dap")

            -- Set up the js-debug adapter using Mason
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "js-debug-adapter", -- This is the name Mason provides
                    args = { "${port}" },
                },
            }

            -- Configure JavaScript and TypeScript launch configurations
            dap.configurations.javascript = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
            }

            dap.configurations.typescript = dap.configurations.javascript

            -- Key mappings for debugging
            vim.keymap.set("n", "<F4>", dap.continue, { desc = "Debug: Continue" })
            vim.keymap.set("n", "<F5>", dap.step_over, { desc = "Debug: Step Over" })
            vim.keymap.set("n", "<F6>", dap.step_into, { desc = "Debug: Step Into" })
            vim.keymap.set("n", "<F7>", dap.step_out, { desc = "Debug: Step Out" })
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Conditional Breakpoint" })
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            -- Auto open/close UI on debugger events
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Keymap to toggle the DAP UI manually
            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
        end,
    },
}
