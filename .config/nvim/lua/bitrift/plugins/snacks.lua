require("snacks").setup({
  gh = {},
  picker = {
    sources = {
      files = {
        ignored = true,
        exclude = { "node_modules", ".git", "dist", "build" },
      },
      grep = {
        ignored = true,
        exclude = { "node_modules", ".git", "dist", "build" },
      },
      gh_issue = {},
      gh_pr = {},
    },
    formatters = {
      file = {
        filename_first = true,
      },
    },
    matcher = {
      frecency = true,
    },
    layout = {
      cycle = false,
    },
  },
  image = {
    enabled = false,
    throttle = 100,
  },
  input = { enabled = true },
  indent = {
    enabled = true,
  },
  dashboard = {
    preset = {
      pick = nil,
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        {
          icon = " ",
          key = "g",
          desc = "Find Text",
          action = ":lua Snacks.dashboard.pick('live_grep')",
        },
        {
          icon = " ",
          key = "r",
          desc = "Recent Files",
          action = ":lua Snacks.dashboard.pick('oldfiles')",
        },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = "📦 ", key = "u", desc = "Update Plugins", action = ":lua vim.pack.update()" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
      header = [[
               ████ ██████           █████      ██                     
              ███████████             █████                             
              █████████ ███████████████████ ███   ███████████   
             █████████  ███    █████████████ █████ ██████████████   
            █████████ ██████████ █████████ █████ █████ ████ █████   
          ███████████ ███    ███ █████████ █████ █████ ████ █████  
         ██████  █████████████████████ ████ █████ █████ ████ ██████ 
      ]],
    },
    sections = {
      { section = "header" },
      {
        section = "keys",
        indent = 1,
        padding = 1,
      },
      { section = "recent_files", icon = " ", title = "Recent Files", indent = 3, padding = 2 },
    },
  },
  terminal = {
    start_insert = true,
    auto_insert = true,
    auto_close = false,
    win = {
      style = "minimal",
      enter = true,
      keys = {
        term_normal = {
          "<esc>",
          function()
            return "<C-\\><C-n>"
          end,
          mode = "t",
          expr = true,
          desc = "Escape to normal mode",
        },
        term_close = {
          "<esc><esc>",
          function()
            vim.cmd("close")
          end,
          mode = "t",
          desc = "Double escape to close terminal",
        },
        q = "hide",
        ["<esc>"] = "hide",
      },
    },
  },
})

vim.keymap.set("n", "<leader>gi", function()
  Snacks.picker.gh_issue()
end, { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>gI", function()
  Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>gp", function()
  Snacks.picker.gh_pr()
end, { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>gP", function()
  Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub Pull Requests (all)" })
vim.keymap.set("n", "gy", function()
  Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gI", function()
  Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
vim.keymap.set("n", "<leader>ps", function()
  Snacks.picker.grep()
end, { desc = "Search in files" })
vim.keymap.set("n", "<leader>pws", function()
  local word = vim.fn.expand("<cword>")
  Snacks.picker.grep({ search = word })
end, { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>u", function()
  Snacks.picker.undo()
end, { desc = "Undo History" })
vim.keymap.set("n", "gd", function()
  Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
vim.keymap.set("n", "td", function()
  Snacks.picker.lsp_type_definitions()
end)
vim.keymap.set("n", "<leader>D", function()
  Snacks.picker.diagnostics({
    on_show = function()
      vim.cmd.stopinsert()
    end,
  })
end, { desc = "All Diagnostics" })
vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Buffer delete" })
vim.keymap.set("n", "<leader>ba", function()
  Snacks.bufdelete.all()
end, { desc = "Buffer delete all" })
vim.keymap.set("n", "<leader><Tab>", function()
  Snacks.picker.files()
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Buffer delete other" })
vim.keymap.set("n", "H", function()
  Snacks.picker.buffers({
    on_show = function()
      vim.cmd.stopinsert()
    end,
    finder = "buffers",
    format = "buffer",
    hidden = false,
    unloaded = true,
    current = true,
    sort_lastused = true,
    win = {
      input = {
        keys = {
          ["d"] = "bufdelete",
        },
      },
      list = { keys = { ["d"] = "bufdelete" } },
    },
  })
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>bz", function()
  Snacks.zen()
end, { desc = "Toggle Zen Mode" })
vim.keymap.set("n", "<leader>?", function()
  Snacks.picker.keymaps({
    layout = { preview = false },
  })
end, { desc = "Keymaps" })

vim.keymap.set("n", "<leader>`", function()
  require("snacks.terminal").toggle()
end, { desc = "Toggle terminal" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit snacks terminal mode" })
vim.o.ttimeoutlen = 0
