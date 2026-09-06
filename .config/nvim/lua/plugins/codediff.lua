require("codediff").setup({})

local git = require("bitrift.utils.git")

vim.keymap.set("n", "<leader>gg", "<cmd>CodeDiff<CR>", { desc = "CodeDiff: Working tree" })
vim.keymap.set("n", "<leader>gd", function()
  vim.ui.input({ prompt = "Compare with branch (empty = branch base): " }, function(branch)
    if branch == nil then
      return
    end

    branch = vim.trim(branch)

    if branch ~= "" then
      vim.cmd("CodeDiff " .. branch)
      return
    end

    local base, ref = git.branch_base()

    if not base then
      vim.notify("CodeDiff: could not find a branch base", vim.log.levels.WARN)
      return
    end

    vim.cmd("CodeDiff " .. base)
    vim.notify("CodeDiff: showing changes since " .. ref .. " fork point", vim.log.levels.INFO)
  end)
end, { desc = "CodeDiff: Compare with branch or base" })
vim.keymap.set("n", "<leader>gh", "<cmd>CodeDiff history %<CR>", { desc = "CodeDiff: File History" })
vim.keymap.set("n", "<leader>gH", "<cmd>CodeDiff history<CR>", { desc = "CodeDiff: Branch History" })
vim.keymap.set("n", "<leader>gc", function()
  -- `codediff.ui.*` is internal per the README (no :CodeDiff close exists); re-check on plugin update.
  local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
  if not (ok and lifecycle.close()) then
    vim.notify("CodeDiff: no session in this tab", vim.log.levels.INFO)
  end
end, { desc = "CodeDiff: Close" })
