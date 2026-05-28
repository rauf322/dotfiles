-- git-worktree.nvim has no setup() — config via vim.g.git_worktree (defaults are fine).
-- Switching calls :cd, which fires DirChanged so auto-session saves/restores per-worktree state automatically.

pcall(function()
  require("telescope").load_extension("git_worktree")
end)

local ok, _ = pcall(require, "telescope")
if not ok then
  return
end

vim.keymap.set("n", "<leader>gw", function()
  require("bitrift.utils.worktree").pick_worktrees()
end, { desc = "Worktree: List/switch" })

vim.keymap.set("n", "<leader>gW", function()
  require("bitrift.utils.worktree").pick_branch_to_create()
end, { desc = "Worktree: Create from branch (Tab = new branch)" })
