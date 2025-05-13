local colors = require("colors")
local settings = require("settings")

-- Equivalent to the --bar domain
sbar.bar({
    color = colors.bar.bg,
    height = settings.height,
    padding_right = 6,
    padding_left = 6,
    sticky = "on",
    topmost = "off",
    y_offset = 7,
})
