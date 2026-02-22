local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

local focused_space = nil
local space_has_windows = {}

local function set_space_visible(i, visible)
	local s = spaces[i]
	if not s then
		return
	end
	if visible then
		s.item:set({
			icon = { drawing = true },
			label = { drawing = true },
			background = { drawing = true },
			padding_right = 1,
			padding_left = 1,
		})
		s.bracket:set({ background = { drawing = true } })
		s.padding:set({ width = settings.group_paddings })
	else
		s.item:set({
			icon = { drawing = false },
			label = { drawing = false },
			background = { drawing = false },
			padding_right = 0,
			padding_left = 0,
		})
		s.bracket:set({ background = { drawing = false } })
		s.padding:set({ width = 0 })
	end
end

local function update_visibility()
	for i, s in pairs(spaces) do
		local is_focused = (i == focused_space)
		local has_windows = space_has_windows[i]
		set_space_visible(i, is_focused or has_windows)
	end
end

for i = 1, 10, 1 do
	local space = sbar.add("space", "space." .. i, {
		space = i,
		icon = {
			font = { family = settings.font.numbers },
			string = i,
			padding_left = 15,
			padding_right = 8,
			color = colors.white,
			highlight_color = colors.red,
		},
		label = {
			padding_right = 10,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = 0,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			color = colors.bg1,
			border_width = 1,
			height = 26,
			border_color = colors.black,
		},
		popup = { background = { border_width = 5, border_color = colors.black } },
	})

	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 28,
			border_width = 2,
		},
	})

	local space_padding = sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
	})

	spaces[i] = {
		item = space,
		bracket = space_bracket,
		padding = space_padding,
	}

	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 0,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2,
			},
		},
	})

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		if selected then
			focused_space = i
		end
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and colors.black or colors.bg2 },
		})
		space_bracket:set({
			background = { border_color = selected and colors.grey or colors.bg2 },
		})
		update_visibility()
	end)

	space:subscribe("mouse.clicked", function(env)
		if env.BUTTON == "other" then
			space_popup:set({ background = { image = "space." .. env.SID } })
			space:set({ popup = { drawing = "toggle" } })
		else
			local op = (env.BUTTON == "right") and "--destroy" or "--focus"
			sbar.exec("yabai -m space " .. op .. " " .. env.SID)
		end
	end)

	space:subscribe("mouse.exited", function(_)
		space:set({ popup = { drawing = false } })
	end)
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_window_observer:subscribe("space_windows_change", function(env)
	local icon_line = ""
	local no_app = true
	for app, count in pairs(env.INFO.apps) do
		no_app = false
		local lookup = app_icons[app]
		local icon = ((lookup == nil) and app_icons["Default"] or lookup)
		icon_line = icon_line .. icon
	end

	local sid = env.INFO.space
	space_has_windows[sid] = not no_app

	if no_app then
		icon_line = " \u{2014}"
	end

	if spaces[sid] then
		sbar.animate("tanh", 10, function()
			spaces[sid].item:set({ label = icon_line })
		end)
	end

	update_visibility()
end)

