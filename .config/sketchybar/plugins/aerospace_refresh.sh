#!/usr/bin/env bash

# Master refresh script - updates ALL workspaces
# Uses Catppuccin Mocha color scheme

source "$CONFIG_DIR/colors.sh"

# Get the currently focused workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused --format "%{workspace}")

# Get all workspaces
for sid in $(aerospace list-workspaces --all); do
  # Build icon string from apps in this workspace
  icons=""
  declare -A seen_apps
  
  # Get apps and monitor info for this workspace
  APPS_INFO=$(aerospace list-windows --workspace "$sid" --json --format "%{monitor-appkit-nsscreen-screens-id}%{app-name}")
  
  # Extract unique apps and build icon string
  IFS=$'\n'
  for app_name in $(echo "$APPS_INFO" | jq -r 'map(.["app-name"]) | .[]'); do
    # Only add each app once (deduplication)
    if [ -z "${seen_apps[$app_name]}" ]; then
      seen_apps[$app_name]=1
      icon=$("$CONFIG_DIR/plugins/icon_map_fn.sh" "$app_name")
      icons+="$icon "
    fi
  done
  
  # Get monitor ID
  monitor=""
  for monitor_id in $(echo "$APPS_INFO" | jq -r 'map(.["monitor-appkit-nsscreen-screens-id"]) | .[]'); do
    monitor=$monitor_id
    break  # Only need one
  done
  
  # Default monitor if none found
  if [ -z "$monitor" ]; then
    monitor="1"
  fi
  
  # Update workspace display based on whether it has apps and is focused
  if [ -z "$icons" ]; then
    # Empty workspace
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
      # Focused but empty - show with border highlight (Catppuccin style)
      sketchybar --set "space.$sid" \
        display="$monitor" \
        drawing=on \
        label=" —" \
        icon.highlight_color="$RED" \
        label.highlight_color="$WHITE" \
        icon.highlight=on \
        label.highlight=on \
        background.border_color="$BLACK" \
        background.drawing=on \
        padding_left=1 \
        padding_right=1
      
      sketchybar --set "space_bracket.$sid" \
        background.border_color="$LAVENDER"
      
      sketchybar --set "space.padding.$sid" \
        drawing=on \
        display="$monitor"
    else
      # Not focused and empty - hide it
      sketchybar --set "space.$sid" \
        drawing=off \
        icon.highlight=off \
        label.highlight=off \
        padding_left=0 \
        padding_right=0
      
      sketchybar --set "space.padding.$sid" \
        drawing=off
    fi
  else
    # Has apps
    if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
      # Focused workspace with apps - Catppuccin highlight
      sketchybar --set "space.$sid" \
        display="$monitor" \
        drawing=on \
        label="$icons" \
        icon.highlight_color="$RED" \
        label.highlight_color="$WHITE" \
        icon.highlight=on \
        label.highlight=on \
        background.border_color="$BLACK" \
        background.drawing=on \
        padding_left=1 \
        padding_right=1
      
      sketchybar --set "space_bracket.$sid" \
        background.border_color="$LAVENDER"
      
      sketchybar --set "space.padding.$sid" \
        drawing=on \
        display="$monitor"
    else
      # Not focused but has apps - Catppuccin unfocused
      sketchybar --set "space.$sid" \
        display="$monitor" \
        drawing=on \
        label="$icons" \
        background.drawing=on \
        background.color="$BG1" \
        background.border_color="$BG1" \
        icon.color="$WHITE" \
        label.color="$LAVENDER" \
        icon.highlight=off \
        label.highlight=off \
        padding_left=1 \
        padding_right=1
      
      sketchybar --set "space_bracket.$sid" \
        background.border_color="$BG2"
      
      sketchybar --set "space.padding.$sid" \
        drawing=on \
        display="$monitor"
    fi
  fi
done
