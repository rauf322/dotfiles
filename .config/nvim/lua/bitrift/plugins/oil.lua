local ok, oil = pcall(require, "oil")
if not ok then
  return
end

-- Oil buffers are editable, so the usual clipboard helpers live on `g` prefixed
-- keys to keep `yy`/`p` free for oil's own copy/paste of files.
local function copy_entry_to_macos_clipboard()
  local entry = oil.get_cursor_entry()
  local dir = oil.get_current_dir()
  if not entry or not dir then
    return
  end
  local path = dir .. entry.name
  -- AppleScript's `set the clipboard to POSIX file` silently leaves the pasteboard empty
  -- about half the time; writing the NSURL to NSPasteboard via JXA is reliable.
  local script = table.concat({
    "ObjC.import('AppKit');",
    "var pb = $.NSPasteboard.generalPasteboard;",
    "pb.clearContents;",
    "pb.writeObjects($.NSArray.arrayWithObject($.NSURL.fileURLWithPath(" .. vim.json.encode(path) .. ")));",
  }, " ")
  local result = vim.system({ "osascript", "-l", "JavaScript", "-e", script }):wait()
  if result.code ~= 0 then
    vim.notify("Clipboard copy failed: " .. vim.trim(result.stderr or ""), vim.log.levels.ERROR)
    return
  end
  vim.notify("Copied to clipboard: " .. entry.name)
end

oil.setup({
  default_file_explorer = true,
  confirmation = {
    border = "rounded",
  },
  float = {
    border = "rounded",
  },
  keymaps = {
    ["gy"] = { callback = copy_entry_to_macos_clipboard, desc = "Copy file to macOS clipboard" },
    ["gp"] = { "actions.yank_entry", opts = { modify = ":p" }, desc = "Yank absolute path" },
    ["gP"] = { "actions.yank_entry", opts = { modify = ":." }, desc = "Yank path relative to cwd" },
    ["<leader>er"] = "actions.refresh",
    ["<leader>ec"] = "actions.close",
  },
  view_options = {
    show_hidden = true,
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function()
    vim.opt_local.colorcolumn = ""
  end,
})

local keymap = vim.keymap
keymap.set("n", "<leader>ef", function()
  oil.toggle_float(vim.fn.getcwd())
end, { desc = "Toggle file explorer (project root)" })
keymap.set("n", "<leader>ff", function()
  local ok_diffview, lib = pcall(require, "diffview.lib")
  if ok_diffview and lib.get_current_view() then
    vim.cmd("DiffviewToggleFiles")
    return
  end

  oil.toggle_float()
end, { desc = "Toggle file explorer on current file" })
keymap.set("n", "-", function()
  oil.open()
end, { desc = "Open parent directory" })
keymap.set("n", "<M-Tab>", function()
  if vim.bo.filetype == "oil" then
    return
  end

  local alt_buf = vim.fn.bufnr("#")
  if alt_buf > 0 and vim.fn.buflisted(alt_buf) == 1 then
    vim.cmd("b#")
  end
end, { desc = "Toggle last buffer" })
