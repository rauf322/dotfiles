return {
  "NickvanDyke/opencode.nvim",
  config = function()
    vim.opt.autoread = true

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<C-N>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask about this" })
    vim.keymap.set("v", "<leader>oa", function()
      require("opencode").ask("@selection: ")
    end, { desc = "opencode: Ask about selection" })
  end,
}
