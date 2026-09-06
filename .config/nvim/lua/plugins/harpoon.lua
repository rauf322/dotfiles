local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>aa", function()
  harpoon:list():add()
end, { desc = "Harpoon: Add file" })

vim.keymap.set("n", "<leader>am", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle menu" })

vim.keymap.set("n", "<leader>ap", function()
  harpoon:list():prev()
end, { desc = "Harpoon: Prev file" })

vim.keymap.set("n", "<leader>an", function()
  harpoon:list():next()
end, { desc = "Harpoon: Next file" })

for i = 1, 4 do
  vim.keymap.set("n", "<leader>" .. i, function()
    harpoon:list():select(i)
  end, { desc = "Harpoon: Select file " .. i })
end
