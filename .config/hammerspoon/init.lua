local audioSwitcher = require("audioSwitcher")

local function reloadYabai()
	local cmd =
		"if command -v yabai >/dev/null 2>&1; then yabai --restart-service || yabai --start-service; elif [ -x /opt/homebrew/bin/yabai ]; then /opt/homebrew/bin/yabai --restart-service || /opt/homebrew/bin/yabai --start-service; else exit 127; fi; if command -v sketchybar >/dev/null 2>&1; then sketchybar --reload; elif [ -x /opt/homebrew/bin/sketchybar ]; then /opt/homebrew/bin/sketchybar --reload; fi"
	hs.task
		.new("/bin/sh", function(code, stdout, stderr)
			print(string.format("[displayWatcher] yabai reload exit=%d", code))
			if stdout and #stdout > 0 then
				print("[displayWatcher] stdout: " .. stdout)
			end
			if stderr and #stderr > 0 then
				print("[displayWatcher] stderr: " .. stderr)
			end
		end, { "-lc", cmd })
		:start()
end

_G.yabaiReloadTimer = nil
_G.displayWatcher = hs.screen.watcher.new(function()
	print("[displayWatcher] screen configuration changed")
	if _G.yabaiReloadTimer then
		_G.yabaiReloadTimer:stop()
	end
	_G.yabaiReloadTimer = hs.timer.doAfter(1.0, reloadYabai)
end)

_G.displayWatcher:start()

audioSwitcher.start({
	preferredSpeaker = "Scarlett Solo USB",
	builtinSpeaker = "Динамики MacBook Pro",
	airPodsName = "Rauf’s AirPods #4",

	includeAirPodsInAuto = true,
	notify = true,
	logDevices = true,
	delays = {
		onAudioEvent = 0.5,
		onWake = 2.0,
		onUsbEvent = 1.0,
		onStart = 0.2,
	},
})

-- Optional: hotkey ⌥⌘A to toggle AirPods ↔ External
hs.hotkey.bind({ "alt", "cmd" }, "A", function()
	audioSwitcher.toggleAirPodsExternal()
end)
