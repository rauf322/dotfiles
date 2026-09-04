vim.opt.autoread = true

local opencode_utils = require("bitrift.utils.opencode")

local opencode_module = "opencode"
local opencode_process_module = "opencode.server.process"
local opencode_terminal_module = "opencode.terminal"
local opencode_cmd = "OPENCODE_EXPERIMENTAL=1 opencode --port --continue"
local opencode_terminal_opts = {
  win = {
    position = "float",
    width = 0,
    height = 0,
    enter = true,
    on_win = function(self)
      vim.wo[self.win].winfixwidth = false
      local ok, terminal = pcall(require, opencode_terminal_module)
      if ok then
        pcall(terminal.setup, self.win)
      end
    end,
    keys = {
      opencode_escape = {
        "<Esc>",
        function()
          vim.api.nvim_chan_send(vim.b.terminal_job_id, "\27")
        end,
        mode = "t",
        desc = "Send Escape to opencode",
      },
      opencode_ctrl_c = {
        "<C-c>",
        function()
          vim.api.nvim_chan_send(vim.b.terminal_job_id, "\3")
        end,
        mode = "t",
        desc = "Send Ctrl-C to opencode",
      },
    },
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    port = function(callback)
      callback(opencode_utils.find_port())
    end,
    start = function()
      require("snacks.terminal").open(opencode_cmd, opencode_terminal_opts)
    end,
  },
}

local ok, opencode_process = pcall(require, opencode_process_module)
if ok then
  opencode_process.get = opencode_utils.processes
end

vim.keymap.set({ "n", "x" }, "<C-N>", function()
  require(opencode_module).ask("@this:", { submit = true })
end, { desc = "Ask opencode…" })

vim.keymap.set("v", "<leader>oa", function()
  require(opencode_module).ask("@selection: ")
end, { desc = "opencode: Ask about selection" })

vim.keymap.set("n", "<leader>oS", function()
  require(opencode_module).select_server()
end, { desc = "opencode: Select server" })
