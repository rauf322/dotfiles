require("auto-session").setup({
  suppressed_dirs = { "~/", "~/Downloads", "/" },
  session_lens = {
    picker = "snacks",
  },
  pre_save_cmds = {
    function()
      -- oil.close() assumes the current window is an oil buffer; on a normal window its
      -- fallback path does `bprev` and force-deletes the buffer under the cursor.
      if vim.bo.filetype == "oil" then
        pcall(function()
          require("oil").close()
        end)
      end
    end,
  },
})

vim.keymap.set("n", "<leader>ss", "<cmd>AutoSession save<cr>", { desc = "Save session" })
vim.keymap.set("n", "<leader>sr", "<cmd>AutoSession restore<cr>", { desc = "Restore session" })
vim.keymap.set("n", "<leader>sd", "<cmd>AutoSession delete<cr>", { desc = "Delete session" })
vim.keymap.set("n", "<leader>sf", "<cmd>AutoSession search<cr>", { desc = "Search sessions" })

-- Neovim 0.12's `:restart` re-execs without firing VimLeavePre, so the session is not
-- saved the way it is on :q/:qa. Save it here so the restarted instance can restore it.
vim.api.nvim_create_user_command("Restart", function()
  local ok, err = pcall(vim.cmd, "AutoSession save")
  if not ok then
    vim.notify("auto-session save failed: " .. err, vim.log.levels.WARN)
  end
  vim.cmd("restart")
end, { desc = "Save session, then :restart" })

-- Typing `:restart` expands to the wrapper; the guard keeps other cmdlines untouched.
vim.cmd([[cnoreabbrev <expr> restart getcmdtype() ==# ':' && getcmdline() ==# 'restart' ? 'Restart' : 'restart']])
