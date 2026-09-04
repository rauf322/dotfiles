local ts_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter"
vim.opt.runtimepath:prepend(ts_path .. "/runtime")

local parser_languages = {
  "bash",
  "c",
  "css",
  "dart",
  "dockerfile",
  "gitignore",
  "graphql",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "prisma",
  "query",
  "svelte",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local function install_missing_parsers()
  local treesitter = require("nvim-treesitter")
  local installed = {}

  for _, language in ipairs(treesitter.get_installed()) do
    installed[language] = true
  end

  local missing = vim.tbl_filter(function(language)
    return not installed[language]
  end, parser_languages)

  if #missing > 0 then
    treesitter.install(missing)
  end
end

require("nvim-treesitter").setup({})
install_missing_parsers()

local treesitter_indent_disabled_filetypes = {
  ocaml = true,
  ["ocaml.interface"] = true,
}

local treesitter_group = vim.api.nvim_create_augroup("bitrift-treesitter-main", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = treesitter_group,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)

    local filetype = vim.bo[args.buf].filetype
    if treesitter_indent_disabled_filetypes[filetype] then
      return
    end

    if not vim.treesitter.get_parser(args.buf, nil, { error = false }) then
      return
    end

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    local has_indents, query = pcall(vim.treesitter.query.get, language, "indents")
    if has_indents and query then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

require("treesitter-context").setup({
  enable = false,
  max_lines = 1,
  trim_scope = "inner",
})

require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
})

-- Treesitter selection + textobjects
local treesitter_select = function()
  if not vim.treesitter.get_parser(0, nil, { error = false }) then
    return nil
  end

  local ok, select = pcall(require, "vim.treesitter._select")
  if ok then
    return select
  end

  return nil
end

local treesitter_select_parent = function()
  local select = treesitter_select()
  if select then
    select.select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end

local treesitter_select_child = function()
  local select = treesitter_select()
  if select then
    select.select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end

local treesitter_select_scope = function()
  local ok = pcall(require("nvim-treesitter-textobjects.select").select_textobject, "@local.scope", "locals")
  if not ok then
    treesitter_select_parent()
  end
end

local treesitter_textobject = function(query, query_group)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, query_group or "textobjects")
  end
end

local treesitter_move = function(method, query, query_group)
  return function()
    require("nvim-treesitter-textobjects.move")[method](query, query_group or "textobjects")
  end
end

vim.keymap.set("n", "<C-Space>", function()
  if treesitter_select() then
    vim.cmd.normal({ "van", bang = true })
  else
    vim.lsp.buf.selection_range(1)
  end
end, { desc = "Treesitter: Start incremental selection" })

vim.keymap.set("x", "<C-Space>", treesitter_select_parent, { desc = "Treesitter: Expand selection" })
vim.keymap.set("x", "<C-s>", treesitter_select_scope, { desc = "Treesitter: Expand to scope" })
vim.keymap.set("x", "<C-BS>", treesitter_select_child, { desc = "Treesitter: Shrink selection" })
vim.keymap.set("x", "<C-h>", treesitter_select_child, { desc = "Treesitter: Shrink selection" })

vim.keymap.set({ "x", "o" }, "aa", treesitter_textobject("@parameter.outer"), { desc = "Select outer parameter" })
vim.keymap.set({ "x", "o" }, "ia", treesitter_textobject("@parameter.inner"), { desc = "Select inner parameter" })
vim.keymap.set({ "x", "o" }, "af", treesitter_textobject("@function.outer"), { desc = "Select outer function" })
vim.keymap.set({ "x", "o" }, "if", treesitter_textobject("@function.inner"), { desc = "Select inner function" })
vim.keymap.set({ "x", "o" }, "ac", treesitter_textobject("@class.outer"), { desc = "Select outer class" })
vim.keymap.set({ "x", "o" }, "ic", treesitter_textobject("@class.inner"), { desc = "Select inner class" })

vim.keymap.set({ "n", "x", "o" }, "]m", treesitter_move("goto_next_start", "@function.outer"), { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "]]", treesitter_move("goto_next_start", "@class.outer"), { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "]M", treesitter_move("goto_next_end", "@function.outer"), { desc = "Next function end" })
vim.keymap.set({ "n", "x", "o" }, "][", treesitter_move("goto_next_end", "@class.outer"), { desc = "Next class end" })
vim.keymap.set({ "n", "x", "o" }, "[m", treesitter_move("goto_previous_start", "@function.outer"), { desc = "Previous function start" })
vim.keymap.set({ "n", "x", "o" }, "[[", treesitter_move("goto_previous_start", "@class.outer"), { desc = "Previous class start" })
vim.keymap.set({ "n", "x", "o" }, "[M", treesitter_move("goto_previous_end", "@function.outer"), { desc = "Previous function end" })
vim.keymap.set({ "n", "x", "o" }, "[]", treesitter_move("goto_previous_end", "@class.outer"), { desc = "Previous class end" })

vim.keymap.set("n", "<leader>p", function()
  require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })
