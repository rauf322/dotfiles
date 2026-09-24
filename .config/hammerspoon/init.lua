local audioSwitcher = require("audioSwitcher")

local function reloadSketchybar()
	hs.task
		.new("/bin/sh", function(code, _, stderr)
			print(string.format("[displayWatcher] sketchybar reload exit=%d", code))
			if stderr and #stderr > 0 then
				print("[displayWatcher] stderr: " .. stderr)
			end
		end, { "-lc", "/opt/homebrew/bin/sketchybar --reload" })
		:start()
end

_G.sketchybarReloadTimer = nil
_G.displayWatcher = hs.screen.watcher.new(function()
	print("[displayWatcher] screen configuration changed")
	if _G.sketchybarReloadTimer then
		_G.sketchybarReloadTimer:stop()
	end
	_G.sketchybarReloadTimer = hs.timer.doAfter(1.0, reloadSketchybar)
end)

_G.displayWatcher:start()

audioSwitcher.start({
	preferredSpeaker = "LC32G7xT",
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
