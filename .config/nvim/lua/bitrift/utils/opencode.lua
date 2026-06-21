local M = {}

local function systemlist(cmd)
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return output
end

local function opencode_pids()
  local output = systemlist({ "pgrep", "-f", "opencode .*--port" })
  if not output then
    return {}
  end

  local pids = {}
  for _, line in ipairs(output) do
    local pid = tonumber(line)
    if pid then
      table.insert(pids, tostring(pid))
    end
  end
  return pids
end

local function listening_processes(pids)
  if #pids == 0 then
    return {}
  end

  local output = systemlist({
    "lsof",
    "-Fpn",
    "-w",
    "-iTCP",
    "-sTCP:LISTEN",
    "-p",
    table.concat(pids, ","),
    "-a",
    "-P",
    "-n",
  })
  if not output then
    return {}
  end

  local processes, seen = {}, {}
  local pid
  for _, line in ipairs(output) do
    if line:sub(1, 1) == "p" then
      pid = tonumber(line:sub(2))
    elseif line:sub(1, 1) == "n" then
      local port = tonumber(line:match(":(%d+)$"))
      if pid and port then
        local key = pid .. ":" .. port
        if not seen[key] then
          seen[key] = true
          table.insert(processes, { pid = pid, port = port })
        end
      end
    end
  end
  return processes
end

local function api_path(port)
  local output = systemlist({ "curl", "-sS", "--max-time", "1", "http://localhost:" .. port .. "/path" })
  if not output then
    return nil
  end

  local ok, decoded = pcall(vim.fn.json_decode, table.concat(output, "\n"))
  if not ok or type(decoded) ~= "table" then
    return nil
  end
  if not decoded.directory and not decoded.worktree then
    return nil
  end
  return decoded
end

local function path_overlaps(left, right)
  if not left or not right then
    return false
  end
  return left:find(right, 1, true) == 1 or right:find(left, 1, true) == 1
end

function M.find_port()
  local cwd = vim.fn.getcwd()

  for _, process in ipairs(M.processes()) do
    local path = process.path
    if path_overlaps(path.directory, cwd) or path_overlaps(path.worktree, cwd) then
      return process.port
    end
  end

  return nil
end

function M.processes()
  local processes = {}
  for _, process in ipairs(listening_processes(opencode_pids())) do
    local path = api_path(process.port)
    if path then
      process.path = path
      table.insert(processes, process)
    end
  end
  return processes
end

return M
