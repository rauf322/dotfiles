vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neo-tree").setup({
  close_if_last_window = true,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,

  window = {
    position = "right",
    width = 30,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["f"] = "noop",
      ["K"] = "navigate_up",
      ["J"] = "set_root",

      ["C"] = function(state)
        local node = state.tree:get_node()
        if not node then
          print("No item selected!")
          return
        end

        local path = vim.fn.expand(node.path)
        path = path:gsub('"', '\\"')

        local applescript_cmd = string.format('osascript -e "set the clipboard to POSIX file \\"%s\\""', path)
        local result = os.execute(applescript_cmd)

        if result == 0 then
          local item_type = node.type == "directory" and "folder" or "file"
          print("Copied " .. item_type .. " to system clipboard: " .. path)
        else
          print("Failed to copy to clipboard")
        end
      end,

      ["P"] = function(state)
        local inputs = require("neo-tree.ui.inputs")
        local node = state.tree:get_node()
        local dir_path = node.type == "directory" and node.path or vim.fn.fnamemodify(node.path, ":h")

        inputs.input("Image filename: ", "", function(filename)
          if not filename or filename == "" then
            return
          end

          if not filename:match("%.png$") then
            filename = filename .. ".png"
          end

          local target_path = dir_path .. "/" .. filename
          local cmd = string.format(
            "osascript -e 'set png_data to the clipboard as «class PNGf»' -e 'set the_file to open for access POSIX file \"%s\" with write permission' -e 'write png_data to the_file' -e 'close access the_file'",
            target_path
          )

          local result = os.execute(cmd)
          if result == 0 then
            print("Pasted image: " .. filename)
            require("neo-tree.sources.manager").refresh("filesystem")
          else
            print("Failed to paste image from clipboard")
          end
        end)
      end,

      ["D"] = function(state)
        local inputs = require("neo-tree.ui.inputs")
        local node = state.tree:get_node()
        if node.type == "message" then
          return
        end
        local msg = "Are you sure you want to delete " .. node.name .. " to trash?"
        inputs.confirm(msg, function(confirmed)
          if not confirmed then
            return
          end

          local trash_cmd = "trash " .. vim.fn.shellescape(node.path)
          local result = vim.fn.system(trash_cmd)
          if vim.v.shell_error == 0 then
            print("Moved to trash: " .. node.name)
            require("neo-tree.sources.manager").refresh("filesystem")
          else
            print("Failed to move to trash: " .. result)
          end
        end)
      end,

      ["<CR>"] = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" then
          require("neo-tree.sources.filesystem").toggle_directory(state, node)
        else
          local current_win = vim.api.nvim_get_current_win()
          local win_ids = vim.api.nvim_tabpage_list_wins(0)
          local target_win = current_win

          for _, win in ipairs(win_ids) do
            local buf = vim.api.nvim_win_get_buf(win)
            local filetype = vim.bo[buf].filetype
            if vim.api.nvim_win_get_config(win).relative == "" and filetype ~= "neo-tree" then
              target_win = win
              break
            end
          end

          if target_win ~= current_win then
            vim.api.nvim_set_current_win(target_win)
          end

          require("neo-tree.sources.filesystem.commands").open(state)
          require("neo-tree.command").execute({ action = "close" })
        end
      end,
    },
  },

  filesystem = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },
    filtered_items = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = false,
      hide_hidden = true,
      hide_by_name = {
        "node_modules",
        ".git",
        "dist",
        "build",
      },
      hide_by_pattern = {
        "*.o",
        "*.a",
        "*.out",
        "*.class",
      },
    },
    use_libuv_file_watcher = true,
  },

  event_handlers = {
    {
      event = "file_opened",
      handler = function()
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
})

local keymap = vim.keymap
keymap.set("n", "<leader>ef", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>ff", function()
  local ok, lib = pcall(require, "diffview.lib")
  if ok and lib.get_current_view() then
    vim.cmd("DiffviewToggleFiles")
    return
  end

  if vim.bo.filetype == "neo-tree" then
    vim.cmd("Neotree close")
  else
    vim.cmd("Neotree reveal")
  end
end, { desc = "Toggle file explorer on current file" })
keymap.set("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Close file explorer" })
keymap.set("n", "<leader>er", "<cmd>Neotree filesystem refresh<CR>", { desc = "Refresh file explorer" })
keymap.set("n", "<M-Tab>", function()
  if vim.bo.filetype == "neo-tree" then
    return
  end
  local alt_buf = vim.fn.bufnr("#")
  if alt_buf > 0 and vim.fn.buflisted(alt_buf) == 1 then
    vim.cmd("b#")
  end
end, { desc = "Toggle last buffer" })
