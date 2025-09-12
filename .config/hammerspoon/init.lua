local audioSwitcher = require("audioSwitcher")

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
