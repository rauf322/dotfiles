#!/bin/bash

# Aerospace workspace items with Catppuccin styling
# This recreates the bash version with the new Catppuccin theme

# Add group padding before workspaces (5px to match Lua settings.group_paddings)
sketchybar --add item space.padding_start left \
  --set space.padding_start \
  width=5

# Create workspace items
for sid in $(aerospace list-workspaces --all); do
  # Get monitor ID for this workspace (default to 1 if not found)
  monitor=$(aerospace list-windows --workspace "$sid" --format "%{monitor-appkit-nsscreen-screens-id}" | head -n 1)

  if [ -z "$monitor" ]; then
    monitor="1"
  fi

  # Add workspace item to SketchyBar with Catppuccin styling
  sketchybar --add item space."$sid" left \
    --subscribe space."$sid" mouse.entered mouse.exited \
    --set space."$sid" \
    display="$monitor" \
    padding_left=1 \
    padding_right=1 \
    icon="$sid" \
    icon.font="SF Mono:Bold:14.0" \
    icon.padding_left=15 \
    icon.padding_right=15 \
    icon.y_offset=0 \
    icon.color="$WHITE" \
    icon.highlight_color="$RED" \
    label.font="sketchybar-app-font:Regular:16.0" \
    label.padding_left=0 \
    label.padding_right=15 \
    label.y_offset=-1 \
    label.color="$LAVENDER" \
    label.highlight_color="$WHITE" \
    background.drawing=on \
    background.color="$BG1" \
    background.border_width=1 \
    background.border_color="$BG1" \
    background.corner_radius=9 \
    background.height=28 \
    click_script="aerospace workspace $sid" \
    script="$CONFIG_DIR/plugins/aerospace.sh $sid"
  
  # Add bracket for double border effect
  sketchybar --add bracket space_bracket."$sid" space."$sid" \
    --set space_bracket."$sid" \
    background.color="$TRANSPARENT" \
    background.height=30 \
    background.border_width=2 \
    background.border_color="$BG2"
  
  # Add spacer between workspaces
  sketchybar --add item space.padding."$sid" left \
    --set space.padding."$sid" \
    width=4 \
    display="$monitor"
done

# Add group padding after workspaces (5px to match Lua settings.group_paddings)
sketchybar --add item space.padding_end left \
  --set space.padding_end \
  width=5

# Create an event watcher that triggers the refresh script
sketchybar --add event aerospace_workspace_change \
           --add item aerospace_watcher left \
           --set aerospace_watcher \
                 drawing=off \
                 updates=on \
                 script="$CONFIG_DIR/plugins/aerospace_refresh.sh" \
           --subscribe aerospace_watcher aerospace_workspace_change front_app_switched

# Initial refresh
"$CONFIG_DIR/plugins/aerospace_refresh.sh"
