require("bqf").setup({
  auto_enable = true,
  auto_resize_height = true,
  preview = {
    win_height = 15,
    win_vheight = 15,
    delay_syntax = 80,
    border = "rounded",
    show_title = true,
    should_preview_cb = function(bufnr)
      local ret = true
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local fsize = vim.fn.getfsize(bufname)
      if fsize > 100 * 1024 then
        ret = false
      end
      return ret
    end,
  },
  func_map = {
    open = "<CR>",
    openc = "o",
    split = "<C-s>",
    vsplit = "<C-v>",
    tab = "t",
    prevfile = "<C-p>",
    nextfile = "<C-n>",
    prevhist = "<",
    nexthist = ">",
    stoggleup = "K",
    stoggledown = "J",
    pscrollup = "<C-u>",
    pscrolldown = "<C-d>",
  },
})
