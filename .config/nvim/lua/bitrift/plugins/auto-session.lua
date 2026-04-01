local function get_git_branch()
  local branch = vim.fn.system("git -C " .. vim.fn.getcwd() .. " branch --show-current 2>/dev/null")
  return vim.fn.trim(branch)
end

require("auto-session").setup({
  suppressed_dirs = { "~/", "~/Downloads", "/" },
  session_lens = {
    load_on_setup = true,
  },
  pre_save_cmds = {
    function()
      pcall(vim.cmd, "Neotree close")
    end,
  },
  post_restore_cmds = {
    function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local name = vim.api.nvim_buf_get_name(buf)
          if name ~= "" and not vim.loop.fs_stat(name) then
            vim.api.nvim_buf_delete(buf, { force = true })
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
