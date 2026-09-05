require("diffview").setup({
  enhanced_diff_hl = true,
  view = {
    default = {
      disable_diagnostics = true,
    },
    merge_tool = {
      layout = "diff3_mixed",
    },
  },
  hooks = {
    -- Diff buffers have bogus paths (diffview://...), so root_dir detection for
    -- servers like tsc/graphql can resolve to "/" and spam init errors; make sure
    -- nothing stays attached even if it slipped in before this buffer was ready.
    diff_buf_read = function(bufnr)
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        vim.lsp.buf_detach_client(bufnr, client.id)
      end
    end,
  },
})

local git = require("bitrift.utils.git")

vim.keymap.set("n", "<leader>gg", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: Open" })
vim.keymap.set("n", "<leader>gd", function()
  vim.ui.input({ prompt = "Compare with branch (empty = branch base): " }, function(branch)
    if branch == nil then
      return
    end

    branch = vim.trim(branch)

    if branch ~= "" then
      vim.cmd("DiffviewOpen " .. branch)
      return
    end

    local base, ref = git.branch_base()

    if not base then
      vim.notify("Diffview: could not find a branch base", vim.log.levels.WARN)
      return
    end

    vim.cmd("DiffviewOpen " .. base)
    vim.notify("Diffview: showing changes since " .. ref .. " fork point", vim.log.levels.INFO)
  end)
end, { desc = "Diffview: Compare with branch or base" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview: File History" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview: Branch History" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<CR>", { desc = "Diffview: Close" })
