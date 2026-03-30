local ts_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter"
vim.opt.runtimepath:prepend(ts_path .. "/runtime")

require("nvim-treesitter").setup()

local parsers = {
  "json",
  "javascript",
  "typescript",
  "tsx",
  "yaml",
  "html",
  "css",
  "prisma",
  "svelte",
  "graphql",
  "bash",
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
  "query",
  "vimdoc",
  "c",
  "markdown",
  "markdown_inline",
}

for _, parser in ipairs(parsers) do
  pcall(function()
    require("nvim-treesitter").install(parser)
  end)
end

local indent_disabled = { javascript = true, typescript = true }

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if ok and not indent_disabled[args.match] then
      vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
    end
  end,
})

vim.keymap.set({ "n", "x" }, "<C-space>", function()
  local ok, inc = pcall(require, "nvim-treesitter.incremental_selection")
  if ok and inc then
    inc.node_incremental()
  end
end, { desc = "Increment treesitter selection" })

vim.keymap.set("x", "<bs>", function()
  local ok, inc = pcall(require, "nvim-treesitter.incremental_selection")
  if ok and inc then
    inc.node_decremental()
  end
end, { desc = "Decrement treesitter selection" })

local to_ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
if to_ok then
  textobjects.setup({
    select = { lookahead = true },
    move = { set_jumps = true },
  })

  local sel = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")

  local select_maps = {
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
  }
  for key, query in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, key, function()
      sel.select_textobject(query)
    end, { desc = "Select " .. query })
  end

  vim.keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer")
  end, { desc = "Next function start" })
  vim.keymap.set({ "n", "x", "o" }, "]]", function()
    move.goto_next_start("@class.outer")
  end, { desc = "Next class start" })
  vim.keymap.set({ "n", "x", "o" }, "]M", function()
    move.goto_next_end("@function.outer")
  end, { desc = "Next function end" })
  vim.keymap.set({ "n", "x", "o" }, "][", function()
    move.goto_next_end("@class.outer")
  end, { desc = "Next class end" })
  vim.keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer")
  end, { desc = "Prev function start" })
  vim.keymap.set({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start("@class.outer")
  end, { desc = "Prev class start" })
  vim.keymap.set({ "n", "x", "o" }, "[M", function()
    move.goto_previous_end("@function.outer")
  end, { desc = "Prev function end" })
  vim.keymap.set({ "n", "x", "o" }, "[]", function()
    move.goto_previous_end("@class.outer")
  end, { desc = "Prev class end" })

  vim.keymap.set("n", "<leader>p", function()
    swap.swap_next("@parameter.inner")
  end, { desc = "Swap next parameter" })
end

require("treesitter-context").setup({ max_lines = 0 })
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#111111" })

require("nvim-ts-autotag").setup({})
