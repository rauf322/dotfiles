vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
  return
end

local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.map.on_attach.default(bufnr)

  vim.keymap.set("n", "y", function()
    local node = api.tree.get_node_under_cursor()
    if not node then
      return
    end
    local path = node.absolute_path:gsub('"', '\\"')
    os.execute('osascript -e "set the clipboard to POSIX file \\"' .. path .. '\\""')
    vim.notify("Copied to clipboard: " .. node.name)
  end, opts("Copy file to macOS clipboard"))
end

nvim_tree.setup({
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  select_prompts = true,

  view = {
    side = "right",
    width = 30,
  },

  update_focused_file = {
    enable = true,
  },

  git = {
    enable = true,
  },

  diagnostics = {
    enable = true,
  },

  filters = {
    dotfiles = true,
    git_ignored = false,
  },

  filesystem_watchers = {
    enable = true,
  },

  actions = {
    use_system_clipboard = true,
    open_file = {
      quit_on_open = true,
    },
  },

  ui = {
    confirm = {
      remove = true,
      trash = true,
    },
  },
})

local keymap = vim.keymap
keymap.set("n", "<leader>ef", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>ff", function()
  local ok_diffview, lib = pcall(require, "diffview.lib")
  if ok_diffview and lib.get_current_view() then
    vim.cmd("DiffviewToggleFiles")
    return
  end

  if vim.bo.filetype == "NvimTree" then
    vim.cmd("NvimTreeClose")
  else
    vim.cmd("NvimTreeFindFile")
  end
end, { desc = "Toggle file explorer on current file" })
keymap.set("n", "<leader>ec", "<cmd>NvimTreeClose<CR>", { desc = "Close file explorer" })
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
keymap.set("n", "<M-Tab>", function()
  if vim.bo.filetype == "NvimTree" then
    return
  end

  local alt_buf = vim.fn.bufnr("#")
  if alt_buf > 0 and vim.fn.buflisted(alt_buf) == 1 then
    vim.cmd("b#")
  end
end, { desc = "Toggle last buffer" })
