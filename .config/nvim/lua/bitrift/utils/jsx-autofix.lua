-- JSX self-closing tag utilities
local M = {}

-- Function to fix JSX self-closing tags in the entire buffer
function M.fix_jsx_self_closing()
  local filetype = vim.bo.filetype

  -- Only run on JSX/TSX files
  if not (filetype == "javascriptreact" or filetype == "typescriptreact") then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local modified = false

  -- Pattern to match <Component></Component> (empty JSX tags)
  local jsx_pattern = "(<[A-Z][%w]*[^/>]*)></[A-Z][%w]*>"

  for i, line in ipairs(lines) do
    if line:match(jsx_pattern) then
      -- Replace with self-closing version
      local new_line = line:gsub(jsx_pattern, "%1 />")
      lines[i] = new_line
      modified = true
    end
  end

  -- Update buffer if any changes were made
  if modified then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify("Fixed JSX self-closing tags", vim.log.levels.INFO)
  end
end

-- Export the module
return M
