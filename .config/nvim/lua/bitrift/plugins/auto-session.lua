local function get_git_branch()
  local branch = vim.fn.system("git -C " .. vim.fn.getcwd() .. " branch --show-current 2>/dev/null")
  return vim.fn.trim(branch)
end

require("auto-session").setup({
  suppressed_dirs = { "~/", "~/Downloads", "/" },
  cwd_change_handling = true,
  session_lens = {
    load_on_setup = true,
  },
  pre_save_cmds = {
    function()
      pcall(vim.cmd, "NvimTreeClose")
    end,
  },
  post_restore_cmds = {
    function()
      -- After a worktree switch, kill buffers that don't belong to the new
      -- cwd. We also drop buffers whose file no longer exists. Skip modified
      -- buffers so we don't lose unsaved work.
      local cwd = vim.fn.getcwd():gsub("/+$", "") .. "/"
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and not vim.bo[buf].modified then
          local name = vim.api.nvim_buf_get_name(buf)
          if name ~= "" then
            local outside_cwd = not vim.startswith(name, cwd)
            local missing = not vim.loop.fs_stat(name)
            if outside_cwd or missing then
              pcall(vim.api.nvim_buf_delete, buf, { force = false })
            end
          end
        end
      end
    end,
  },
  session_name_to_dir = function(name)
    return name
  end,
  dir_to_session_name = function(dir)
    local branch = get_git_branch()
    local base = vim.fn.fnamemodify(dir, ":t")
    if branch ~= "" then
      return base .. "_" .. branch:gsub("[^%w%-]", "_")
    end
    return base
  end,
})

vim.keymap.set("n", "<leader>ss", "<cmd>AutoSession save<cr>", { desc = "Save session" })
vim.keymap.set("n", "<leader>sr", "<cmd>AutoSession restore<cr>", { desc = "Restore session" })
vim.keymap.set("n", "<leader>sd", "<cmd>AutoSession delete<cr>", { desc = "Delete session" })
vim.keymap.set("n", "<leader>sf", "<cmd>AutoSession search<cr>", { desc = "Search sessions" })
