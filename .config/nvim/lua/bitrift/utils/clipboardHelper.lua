local M = {}

function M.copy_file_to_clipboard()
  local api = require("nvim-tree.api")
  local node = api.tree.get_node_under_cursor()

  if not node then
    print("No item selected!")
    return
  end

  -- Expand the absolute path (handles ~)
  local path = vim.fn.expand(node.absolute_path)
  -- Escape any double quotes in the path
  path = path:gsub('"', '\\"')

  -- Build AppleScript command (works for both files and folders)
  local applescript_cmd = string.format('osascript -e "set the clipboard to POSIX file \\"%s\\""', path)

  -- Execute command and capture status
  local result = os.execute(applescript_cmd)
  if result == 0 then
    local item_type = node.type == "directory" and "folder" or "file"
    print("Copied " .. item_type .. " to system clipboard: " .. path)
  else
    print("Failed to copy to clipboard")
  end
end

return M
