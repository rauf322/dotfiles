-- audioSwitcher.lua
-- Equal priority between Preferred External and AirPods, fallback to Built-in.
-- Remembers last choice via hs.settings so it persists across reloads.

local M = {}

-- Defaults
local CFG = {
	preferredSpeaker = "Scarlett Solo USB",
	builtinSpeaker = "Динамики MacBook Pro",
	airPodsName = "Rauf’s AirPods #4",

	includeAirPodsInAuto = true, -- considered in auto decisions

	notify = true,
	logDevices = true,
	delays = { onAudioEvent = 0.5, onWake = 2.0, onUsbEvent = 1.0, onStart = 0.2 },
}

local sleepWatcher, usbWatcher, menu
local SETTINGS_KEY = "audioSwitcher.lastChoice" -- "external" | "airpods"

-- utils
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

local function allOutputs()
	return hs.audiodevice.allOutputDevices()
end
local function allInputs()
	return hs.audiodevice.allInputDevices()
end
local function currentOutput()
	return hs.audiodevice.defaultOutputDevice()
end

local function setAsDefault(dev)
	dev:setDefaultOutputDevice()
	dev:setDefaultEffectDevice()
	notify("Switched to " .. dev:name())
end

local function setMicToBuiltin()
	for _, d in pairs(allInputs()) do
		if d:name() == "MacBook Pro Microphone" then
			d:setDefaultInputDevice()
			notify("Microphone → " .. d:name())
			return
		end
	end
end

local function findByExact(name)
	for _, d in pairs(allOutputs()) do
		if d:name() == name then
			return d
		end
	end
end

local function findByContains(substr)
	for _, d in pairs(allOutputs()) do
		if string.find(d:name(), substr, 1, true) then
			return d
		end
	end
end

-- presence helpers
local function getExternal()
	return findByContains(CFG.preferredSpeaker)
end
local function getAirPods()
	return CFG.airPodsName and (findByExact(CFG.airPodsName) or findByContains(CFG.airPodsName)) or nil
end
local function getBuiltin()
	return findByExact(CFG.builtinSpeaker)
end

-- Remember last choice
local function setLastChoice(choice)
	hs.settings.set(SETTINGS_KEY, choice)
end
local function getLastChoice()
	return hs.settings.get(SETTINGS_KEY)
end

-- Manual switchers (also record last choice)
function M.switchToAirPods()
	local dev = getAirPods()
	if dev then
		if not currentOutput() or currentOutput():name() ~= dev:name() then
			setAsDefault(dev)
		else
			notify("Already on " .. dev:name())
		end
		setLastChoice("airpods")
	else
		notify("AirPods not found")
	end
	setMicToBuiltin()
end

function M.switchToExternal()
	local dev = getExternal()
	if dev then
		if not currentOutput() or currentOutput():name() ~= dev:name() then
			setAsDefault(dev)
		else
			notify("Already on " .. dev:name())
		end
		setLastChoice("external")
	else
		notify("Preferred external not found")
	end
	setMicToBuiltin()
end

function M.switchToBuiltin()
	local dev = getBuiltin()
	if dev then
		if not currentOutput() or currentOutput():name() ~= dev:name() then
			setAsDefault(dev)
		else
			notify("Already on " .. dev:name())
		end
	else
		notify("Built-in speakers not found")
	end
	setMicToBuiltin()
end

-- Toggle between AirPods and External (equal priority)
function M.toggleAirPodsExternal()
	local cur = currentOutput()
	if cur and CFG.airPodsName and string.find(cur:name(), CFG.airPodsName, 1, true) then
		M.switchToExternal()
	else
		M.switchToAirPods()
	end
end

-- Auto logic with equal priority:
-- 1) If current is AirPods or External → respect it (do nothing).
-- 2) If neither, and both available → pick lastChoice (default to external if none).
-- 3) If only one of {AirPods, External} available → pick that.
-- 4) Else → Built-in.
local function switchToPreferredAudio_Auto()
	local curName = currentOutput() and currentOutput():name() or ""
	local ext = getExternal()
	local pods = CFG.includeAirPodsInAuto and getAirPods() or nil
	local built = getBuiltin()

	local onExternal = ext and curName == ext:name()
	local onAirPods = pods and curName == pods:name()

	if onExternal or onAirPods then
		print("[audioSwitcher] Respecting current choice:", curName)
		setMicToBuiltin()
		return
	end

	if ext and pods then
		local last = getLastChoice() or "external"
		if last == "airpods" then
			M.switchToAirPods()
		else
			M.switchToExternal()
		end
		return
	end

	if ext then
		M.switchToExternal()
		return
	end
	if pods then
		M.switchToAirPods()
		return
	end

	if built then
		M.switchToBuiltin()
		return
	end

	print("[audioSwitcher] No matching devices to switch to")
end

-- Expose manual trigger
function M.switchNow()
	switchToPreferredAudio_Auto()
end

function M.start(userCfg)
	merge(CFG, userCfg or {})
	notify("Auto audio switching is active")

	hs.audiodevice.watcher.setCallback(function(event)
		print("[audioSwitcher] Audio event:", event)
		hs.timer.doAfter(CFG.delays.onAudioEvent, function()
			switchToPreferredAudio_Auto()
		end)
	end)
	hs.audiodevice.watcher.start()

	sleepWatcher = hs.caffeinate.watcher.new(function(e)
		if e == hs.caffeinate.watcher.systemDidWake then
			print("[audioSwitcher] Wake → check audio")
			hs.timer.doAfter(CFG.delays.onWake, function()
				switchToPreferredAudio_Auto()
			end)
		end
	end)
	sleepWatcher:start()

	usbWatcher = hs.usb.watcher.new(function(_)
		print("[audioSwitcher] USB change → check audio")
		hs.timer.doAfter(CFG.delays.onUsbEvent, function()
			switchToPreferredAudio_Auto()
		end)
	end)
	usbWatcher:start()

	hs.timer.doAfter(CFG.delays.onStart, function()
		switchToPreferredAudio_Auto()
	end)

	return M
end

function M.stop()
	if sleepWatcher then
		sleepWatcher:stop()
	end
	if usbWatcher then
		usbWatcher:stop()
	end
	hs.audiodevice.watcher.setCallback(nil)
	hs.audiodevice.watcher.stop()
	if menu then
		menu:delete()
		menu = nil
	end
	notify("Audio switching stopped")
end

return M
