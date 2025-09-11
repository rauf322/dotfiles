-- audioSwitcher.lua
-- Auto-switch audio output based on preferred device order.
-- Usage (in init.lua):
--   require("audioSwitcher").start({
--     preferredSpeaker = "LC32G7xT",
--     builtinSpeaker   = "Динамики MacBook Pro",
--     eqMacSpeaker     = "Динамики MacBook Pro (eqMac)",
--   })

local M = {}

-- Defaults (can be overridden from init.lua)
local CFG = {
	preferredSpeaker = "LC32G7xT",
	builtinSpeaker = "Динамики MacBook Pro",
	eqMacSpeaker = "Динамики MacBook Pro (eqMac)",
	notify = true,
	logDevices = true, -- print device list on checks
	delays = {
		onAudioEvent = 0.5, -- after audio event
		onWake = 2.0, -- after system wake
		onUsbEvent = 1.0, -- after USB change
		onStart = 0.2, -- after config load
	},
}

-- Keep watcher refs so they don't get garbage-collected
local sleepWatcher
local usbWatcher

-- Utility: shallow-merge tables
local function merge(dst, src)
	if not src then
		return dst
	end
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" then
			merge(dst[k], v)
		else
			dst[k] = v
		end
	end
	return dst
end

local function notify(msg)
	if CFG.notify then
		hs.notify.new({ title = "Audio Switcher", informativeText = msg }):send()
	end
	print("[audioSwitcher] " .. msg)
end

local function switchToPreferredAudio()
	local currentDevice = hs.audiodevice.defaultOutputDevice()
	local devices = hs.audiodevice.allOutputDevices()

	if CFG.logDevices then
		print("[audioSwitcher] Available audio devices:")
		for _, device in pairs(devices) do
			print("  - " .. device:name())
		end
		if currentDevice then
			print("[audioSwitcher] Current device: " .. currentDevice:name())
		end
	end

	-- Helper to set both output & effects
	local function setAsDefault(device)
		device:setDefaultOutputDevice()
		device:setDefaultEffectDevice()
		notify("Switched to " .. device:name())
	end

	-- 1) Preferred external (substring match, plain=true)
	for _, device in pairs(devices) do
		if string.find(device:name(), CFG.preferredSpeaker, 1, true) then
			if not currentDevice or currentDevice:name() ~= device:name() then
				setAsDefault(device)
			else
				print("[audioSwitcher] Already using: " .. device:name())
			end
			return
		end
	end

	-- 2) eqMac virtual device (exact match)
	for _, device in pairs(devices) do
		if device:name() == CFG.eqMacSpeaker then
			if not currentDevice or currentDevice:name() ~= device:name() then
				setAsDefault(device)
			else
				print("[audioSwitcher] Already using: " .. device:name())
			end
			return
		end
	end

	-- 3) Built-in speakers (exact match)
	for _, device in pairs(devices) do
		if device:name() == CFG.builtinSpeaker then
			if not currentDevice or currentDevice:name() ~= device:name() then
				setAsDefault(device)
			else
				print("[audioSwitcher] Already using: " .. device:name())
			end
			return
		end
	end

	print("[audioSwitcher] No matching audio devices found!")
end

-- Expose a manual trigger if you want it
function M.switchNow()
	switchToPreferredAudio()
end

function M.start(userCfg)
	merge(CFG, userCfg or {})

	-- 🔔 Startup message
	notify("Auto audio switching is active")

	-- ✅ Audio device watcher (singleton)
	hs.audiodevice.watcher.setCallback(function(event)
		print("[audioSwitcher] Audio event:", event)
		hs.timer.doAfter(CFG.delays.onAudioEvent, switchToPreferredAudio)
	end)
	hs.audiodevice.watcher.start()

	-- 🌙 Wake watcher
	sleepWatcher = hs.caffeinate.watcher.new(function(eventType)
		if eventType == hs.caffeinate.watcher.systemDidWake then
			print("[audioSwitcher] System woke—checking audio")
			hs.timer.doAfter(CFG.delays.onWake, switchToPreferredAudio)
		end
	end)
	sleepWatcher:start()

	-- 🔌 USB watcher (helps with USB DACs)
	usbWatcher = hs.usb.watcher.new(function(_data)
		print("[audioSwitcher] USB change—checking audio")
		hs.timer.doAfter(CFG.delays.onUsbEvent, switchToPreferredAudio)
	end)
	usbWatcher:start()

	-- ▶️ Initial pass
	print("[audioSwitcher] Started")
	hs.timer.doAfter(CFG.delays.onStart, switchToPreferredAudio)

	return M
end

function M.stop()
	-- Stop the pieces we control; audio watcher is a singleton
	if sleepWatcher then
		sleepWatcher:stop()
	end
	if usbWatcher then
		usbWatcher:stop()
	end
	hs.audiodevice.watcher.setCallback(nil)
	hs.audiodevice.watcher.stop()
	notify("Audio switching stopped")
end

return M
