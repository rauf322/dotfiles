-- git-worktree.nvim has no setup() — config via vim.g.git_worktree (defaults are fine).
-- Switching calls :cd, which fires DirChanged so auto-session saves/restores per-worktree state automatically.

pcall(function()
  require("telescope").load_extension("git_worktree")
end)

local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

-- Custom worktree picker so we can bind `D` in normal mode to delete.
-- The plugin's built-in picker hardcodes its mappings and can't be extended.
local function pick_worktrees()
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
    -- Switch away first so we don't try to delete the active worktree.
    pcall(git_worktree.switch_worktree, nil)
    git_worktree.delete_worktree(path, false, {
      on_failure = function()
        local force = vim.fn.input("Force delete? [y/N]: ")
        if force:lower():sub(1, 1) == "y" then
          git_worktree.delete_worktree(path, true, {})
        end
      end,
      on_success = function()
        print(" - deleted " .. path)
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
        map("n", "D", delete_selected)
        map("i", "<M-d>", delete_selected)
        map("n", "<M-d>", delete_selected)
        return true
      end,
    })
    :find()
end

vim.keymap.set("n", "<leader>gw", pick_worktrees, { desc = "Worktree: List/switch" })

vim.keymap.set("n", "<leader>gW", function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local git_worktree = require("git-worktree")

  require("telescope.builtin").git_branches({
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selected = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not selected then
          return
        end

        local value = selected.value

        -- Distinguish remote vs local by asking git directly. Avoids the
        -- "split on first /" heuristic which is wrong for local branch
        vim.fn.systemlist({ "git", "rev-parse", "--verify", "--quiet", "refs/remotes/" .. value })
        local is_remote = vim.v.shell_error == 0

        local branch, upstream
        if is_remote then
          -- value = "origin/feature/foo" → branch = "feature/foo", upstream = "origin/feature/foo"
          local _, rest = value:match("^([^/]+)/(.+)$")
          branch = rest
          upstream = value
        else
          branch = value
          upstream = nil
        end

        local short = (branch:gsub("/", "-"))
        -- Place new worktrees inside the git common dir (the bare repo for
        -- bare setups, otherwise the repo root). Falls back to the cwd's
        -- parent if git can't tell us.
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

          -- A new worktree has no saved auto-session, so buffers from the
          -- old worktree carry over after :cd. Register a one-shot DirChanged
          -- autocmd that wipes non-modified buffers once the cwd change lands.
          -- Safety: cancel after 5s if no DirChanged fires (e.g. create failed),
          -- otherwise a later <leader>gw switch would wrongly trip the wipe.
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
      end)
      return true
    end,
  })
end, { desc = "Worktree: Create from branch" })
