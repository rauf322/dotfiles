local chainsaw = require("chainsaw")

chainsaw.setup({
  visuals = {
    icon = "󰹈",
    signHlgroup = "DiagnosticSignInfo",
  },
})

local function map(lhs, fn, desc, modes)
  vim.keymap.set(modes or "n", lhs, function()
    chainsaw[fn]()
  end, { desc = desc })
end

map("<leader>Lg", "variableLog", "Log variable", { "n", "x" })
map("<leader>Lo", "objectLog", "Log object (JSON.stringify)", { "n", "x" })
map("<leader>Lt", "typeLog", "Log typeof", { "n", "x" })
map("<leader>La", "assertLog", "Assert variable", { "n", "x" })
map("<leader>Lm", "messageLog", "Log message")
map("<leader>Le", "emojiLog", "Log emoji (control flow)")
map("<leader>Ls", "stacktraceLog", "Log stacktrace")
map("<leader>Ld", "debugLog", "Insert debugger")
map("<leader>LT", "timeLog", "Time log (start / stop)")
map("<leader>Lc", "clearLog", "Console clear")
map("<leader>Lr", "removeLogs", "Remove all chainsaw logs", { "n", "x" })

vim.keymap.set("n", "<leader>Lf", function()
  local marker = require("chainsaw.config.config").config.marker
  require("snacks").picker.grep_word({
    title = marker .. " log statements",
    cmd = "rg",
    args = { "--trim" },
    search = marker,
    regex = false,
    live = false,
  })
end, { desc = "Find chainsaw logs in project" })
