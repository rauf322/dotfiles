-- init.lua
local audioSwitcher = require("audioSwitcher")

audioSwitcher.start({
	preferredSpeaker = "LC32G7xT",
	builtinSpeaker = "Динамики MacBook Pro",
	eqMacSpeaker = "Динамики MacBook Pro (eqMac)",

	notify = true, -- ✅ system notifications enabled
	logDevices = true, -- ✅ print device list in Hammerspoon console

	delays = {
		onAudioEvent = 0.5, -- wait before switching after audio change
		onWake = 2.0, -- wait after system wakes up
		onUsbEvent = 1.0, -- wait after USB device change
		onStart = 0.2, -- wait after config reload/startup
	},
})
