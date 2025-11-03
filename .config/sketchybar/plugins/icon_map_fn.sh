#!/bin/bash

# Icon mapping function - uses Lua helper to get icons
# This is a simple wrapper that calls the Lua app_icons helper

APP_NAME="$1"

# Use Lua to get the icon from app_icons.lua
icon=$(lua -e "
package.path = package.path .. ';$CONFIG_DIR/helpers/?.lua'
local app_icons = require('app_icons')
local icon = app_icons['$APP_NAME'] or app_icons['Default']
print(icon)
")

echo "$icon"
