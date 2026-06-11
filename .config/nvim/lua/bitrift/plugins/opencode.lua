vim.opt.autoread = true

local opencode_cmd = "OPENCODE_EXPERIMENTAL=1 opencode --port --continue"
local opencode_terminal_opts = {
  win = {
    position = "float",
    width = 0,
    height = 0,
    enter = true,
    on_win = function(self)
      vim.wo[self.win].winfixwidth = false
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
    start = function()
      require("snacks.terminal").open(opencode_cmd, opencode_terminal_opts)
    end,
  },
}

vim.keymap.set({ "n", "x" }, "<C-N>", function()
  require("opencode").ask("@this:", { submit = true })
end, { desc = "Ask opencode…" })

vim.keymap.set("v", "<leader>oa", function()
  require("opencode").ask("@selection: ")
end, { desc = "opencode: Ask about selection" })

vim.keymap.set("n", "<leader>oS", function()
  require("opencode").select_server()
end, { desc = "opencode: Select server" })

vim.keymap.set({ "n", "t" }, "<C-p>", function()
  require("snacks.terminal").toggle(opencode_cmd, opencode_terminal_opts)
end, { desc = "Toggle opencode" })
