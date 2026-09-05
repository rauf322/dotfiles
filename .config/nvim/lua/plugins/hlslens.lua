require("hlslens").setup({
  calm_down = true,
  nearest_only = true,
})

-- `n`/`N` keep the `zzzv` centering from keymaps.lua; the lens is started after the motion.
local function motion_then_lens(keys)
  return "<Cmd>execute('normal! ' . v:count1 . '" .. keys .. "')<CR><Cmd>lua require('hlslens').start()<CR>"
end

vim.keymap.set("n", "n", motion_then_lens("nzzzv"), { silent = true, desc = "Next search match" })
vim.keymap.set("n", "N", motion_then_lens("Nzzzv"), { silent = true, desc = "Prev search match" })
vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], { silent = true, desc = "Search word forward" })
vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], { silent = true, desc = "Search word backward" })
vim.keymap.set("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], { silent = true, desc = "Search partial word forward" })
vim.keymap.set("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], { silent = true, desc = "Search partial word backward" })
