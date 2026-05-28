local M = {}

-- Internal: create a worktree for the given branch value (existing local,
-- existing remote, or a brand new branch name). Prompts for the target path.
local function create_worktree_for(value)
  local git_worktree = require("git-worktree")

  -- Decide whether `value` is a known remote, known local branch, or a new name.
  vim.fn.systemlist({ "git", "rev-parse", "--verify", "--quiet", "refs/remotes/" .. value })
  local is_remote = vim.v.shell_error == 0
  vim.fn.systemlist({ "git", "rev-parse", "--verify", "--quiet", "refs/heads/" .. value })
  local is_local = vim.v.shell_error == 0

  local branch, upstream
  if is_remote then
    -- value = "origin/feature/foo" → branch = "feature/foo", upstream = "origin/feature/foo"
    local _, rest = value:match("^([^/]+)/(.+)$")
    branch = rest
    upstream = value
  elseif is_local then
    branch = value
    upstream = nil
  else
    -- New branch name typed by the user — created off current HEAD.
    branch = value
    upstream = nil
  end

  local short = (branch:gsub("/", "-"))
  local common_dir = vim.fn.systemlist({ "git", "rev-parse", "--path-format=absolute", "--git-common-dir" })[1]
  local base
  if vim.v.shell_error == 0 and common_dir and common_dir ~= "" then
    base = (common_dir:gsub("/%.git/?$", ""))
  else
    base = vim.fn.fnamemodify(vim.fn.getcwd(), ":h")
  end
  local default_path = base .. "/" .. short

  vim.ui.input({ prompt = "Worktree path: ", default = default_path }, function(path)
    if not path or path == "" then
      return
    end

    -- Wipe stale buffers once :cd lands. Safety-cancel after 5s.
    local au_id = vim.api.nvim_create_autocmd("DirChanged", {
      once = true,
      callback = function()
        vim.schedule(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and not vim.bo[buf].modified then
              pcall(vim.api.nvim_buf_delete, buf, { force = false })
            end
          end
        end)
      end,
    })
    vim.defer_fn(function()
      pcall(vim.api.nvim_del_autocmd, au_id)
    end, 5000)

    git_worktree.create_worktree(path, branch, upstream)
  end)
end

-- Custom worktree picker — the git-worktree.nvim built-in picker hardcodes its
-- mappings, so we roll our own to add `D` / `<C-d>` for delete.
function M.pick_worktrees()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local action_set = require("telescope.actions.set")
  local git_worktree = require("git-worktree")

  local raw = vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    vim.notify("git worktree list failed", vim.log.levels.ERROR)
    return
  end

  local entries, current = {}, {}
  for _, line in ipairs(raw) do
    if line == "" then
      if current.path and current.path ~= "" then
        table.insert(entries, current)
      end
      current = {}
    else
      local key, val = line:match("^(%S+)%s*(.*)$")
      if key == "worktree" then
        current.path = val
      elseif key == "HEAD" then
        current.sha = val:sub(1, 8)
      elseif key == "branch" then
        current.branch = val:gsub("^refs/heads/", "")
      elseif line == "bare" then
        current.bare = true
      end
    end
  end
  if current.path and current.path ~= "" then
    table.insert(entries, current)
  end

  local results = {}
  for _, e in ipairs(entries) do
    if not e.bare then
      table.insert(results, e)
    end
  end

  local function delete_selected(prompt_bufnr)
    local sel = action_state.get_selected_entry()
    if not sel then
      return
    end
    local path = sel.value.path
    local confirm = vim.fn.input("Delete worktree " .. path .. "? [y/N]: ")
    if confirm:lower():sub(1, 1) ~= "y" then
      print(" - cancelled")
      return
    end
    actions.close(prompt_bufnr)
    pcall(git_worktree.switch_worktree, nil)
    local reopen = function()
      vim.schedule(function()
        M.pick_worktrees()
      end)
    end
    git_worktree.delete_worktree(path, false, {
      on_failure = function()
        local force = vim.fn.input("Force delete? [y/N]: ")
        if force:lower():sub(1, 1) == "y" then
          git_worktree.delete_worktree(path, true, {
            on_success = function()
              print(" - deleted " .. path)
              reopen()
            end,
          })
        end
      end,
      on_success = function()
        print(" - deleted " .. path)
        reopen()
      end,
    })
  end

  pickers
    .new({}, {
      prompt_title = "Git Worktrees",
      finder = finders.new_table({
        results = results,
        entry_maker = function(e)
          local display = string.format("%-30s %s %s", e.branch or "(detached)", e.sha or "", e.path)
          return { value = e, ordinal = (e.branch or "") .. " " .. e.path, display = display, path = e.path }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(_, map)
        action_set.select:replace(function(prompt_bufnr)
          local sel = action_state.get_selected_entry()
          if not sel then
            return
          end
          actions.close(prompt_bufnr)
          git_worktree.switch_worktree(sel.value.path)
        end)
        map("i", "<C-d>", delete_selected)
        map("n", "<C-d>", delete_selected)
        return true
      end,
    })
    :find()
end

-- Open the branch picker for creating a new worktree. `<CR>` on a match uses
-- that branch; `<Tab>` (or `<CR>` with no match) uses the typed text as a
-- brand new branch name off current HEAD.
function M.pick_branch_to_create()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local function use_typed_name(prompt_bufnr)
    local typed = action_state.get_current_line()
    actions.close(prompt_bufnr)
    if not typed or typed == "" then
      vim.notify("Type a branch name first", vim.log.levels.WARN)
      return
    end
    create_worktree_for(typed)
  end

  require("telescope.builtin").git_branches({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selected = action_state.get_selected_entry()
        local typed = action_state.get_current_line()
        actions.close(prompt_bufnr)
        local value = selected and selected.value or typed
        if not value or value == "" then
          return
        end
        create_worktree_for(value)
      end)
      map("i", "<Tab>", use_typed_name)
      map("n", "<Tab>", use_typed_name)
      return true
    end,
  })
end

return M
