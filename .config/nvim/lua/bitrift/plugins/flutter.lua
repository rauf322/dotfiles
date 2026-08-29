pcall(vim.cmd.packadd, "nvim-dap")
pcall(vim.cmd.packadd, "flutter-tools.nvim")

local ok, flutter_tools = pcall(require, "flutter-tools")
if not ok then
  vim.notify("flutter-tools.nvim is unavailable", vim.log.levels.WARN)
  return
end

flutter_tools.setup({
  debugger = {
    enabled = true,
  },
})

vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRun<CR>", { desc = "Flutter run" })
vim.keymap.set("n", "<leader>fD", "<cmd>FlutterDebug<CR>", { desc = "Flutter debug" })
vim.keymap.set("n", "<leader>fd", "<cmd>FlutterDevices<CR>", { desc = "Flutter devices" })
vim.keymap.set("n", "<leader>fl", "<cmd>FlutterReload<CR>", { desc = "Flutter hot reload" })
vim.keymap.set("n", "<leader>fq", "<cmd>FlutterQuit<CR>", { desc = "Flutter quit" })
