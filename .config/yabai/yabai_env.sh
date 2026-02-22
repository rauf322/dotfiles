#!/usr/bin/env bash

# Filename: ~/github/dotfiles-latest/yabai/yabai_env.sh
# ~/github/dotfiles-latest/yabai/yabai_env.sh

# To get the names of all the running applications
# yabai -m query --windows | jq -r '.[].app'


display_resolution=$(system_profiler SPDisplaysDataType | grep Resolution)
if [[ $(echo "$display_resolution" | grep -c "Resolution") -ge 2 ]]; then
  apps_stream="(Microsoft Edge|OBS Studio|Jitsi Meet|Discord)"
  # This keeps apps always below, seems to be working fine when I switch to other
  # apps
  apps_mgoff_below="(Calculator|iStat Menus|Hammerspoon|BetterDisplay|GIMP|Notes|Activity Monitor|App StoreSoftware Update|TestRig|Gemini|Raycast|OBS Studio|Microsoft Edge|Cisco Packet Tracer|Stickies|ProLevel|Photo Booth|Hand Mirror|SteerMouse|remote-viewer|Jitsi Meet|DaVinci Resolve|Discord|Vivaldi|Electron|Microsoft Outlook|Terminal)"
else
  apps_stream="()"
  # This keeps apps always below, seems to be working fine when I switch to other
  # apps
  apps_mgoff_below="(System Settings|Calculator|iStat Menus|Hammerspoon|BetterDisplay|GIMP|Notes|Activity Monitor|App StoreSoftware Update|TestRig|Gemini|Raycast|OBS Studio|Microsoft Edge|Cisco Packet Tracer|Stickies|ProLevel|Photo Booth|Hand Mirror|SteerMouse|remote-viewer|Jitsi Meet|DaVinci Resolve|Electron|Microsoft Outlook|Terminal)"
fi


