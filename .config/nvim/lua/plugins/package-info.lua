require("package-info").setup({
  autostart = false,
  hide_up_to_date = true,
})

-- The plugin's own autostart matches *any* buffer named package.json, including
-- diff viewers' virtual revision buffers; `npm outdated` then gets a cwd that
-- doesn't exist and jobstart raises E475 mid-render. Only autostart on real files.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("bitrift_package_info_autostart", { clear = true }),
  pattern = "package.json",
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "" or not vim.uv.fs_stat(vim.api.nvim_buf_get_name(ev.buf)) then
      return
    end
    require("package-info").show()
  end,
})

vim.keymap.set("n", "<leader>ns", function()
  require("package-info").show()
end, { desc = "Package: Show versions" })
vim.keymap.set("n", "<leader>nu", function()
  require("package-info").update()
end, { desc = "Package: Update dependency" })
vim.keymap.set("n", "<leader>nd", function()
  require("package-info").delete()
end, { desc = "Package: Delete dependency" })
vim.keymap.set("n", "<leader>ni", function()
  require("package-info").install()
end, { desc = "Package: Install dependency" })
vim.keymap.set("n", "<leader>np", function()
  require("package-info").change_version()
end, { desc = "Package: Change version" })
vim.keymap.set("n", "<leader>nt", function()
  require("package-info").toggle()
end, { desc = "Package: Toggle versions" })
