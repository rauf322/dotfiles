local M = {}

local function git_output(args)
  local command = vim.list_extend({ "git" }, args)
  local ok, output = pcall(vim.fn.systemlist, command)

  if not ok or vim.v.shell_error ~= 0 then
    return nil
  end

  return output
end

local function git_first_line(args)
  local output = git_output(args)

  if not output or output[1] == nil or output[1] == "" then
    return nil
  end

  return output[1]
end

local function git_ref_exists(ref)
  return git_first_line({ "rev-parse", "--verify", "--quiet", ref }) ~= nil
end

local function branch_base_candidates()
  local candidates = {}
  local default_remote = git_first_line({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })

  if default_remote then
    table.insert(candidates, default_remote)
  end

  vim.list_extend(candidates, { "origin/main", "origin/master", "main", "master", "trunk", "develop", "dev" })

  return candidates
end

function M.branch_base()
  local current_branch = git_first_line({ "branch", "--show-current" })

  for _, ref in ipairs(branch_base_candidates()) do
    if ref ~= current_branch and git_ref_exists(ref) then
      local fork_point = git_first_line({ "merge-base", "--fork-point", ref, "HEAD" })
      local merge_base = fork_point or git_first_line({ "merge-base", "HEAD", ref })

      if merge_base then
        return merge_base, ref
      end
    end
  end

  return nil, nil
end

return M
