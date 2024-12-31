#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

# Limit the number of workspaces to 10
sids=( $(aerospace list-workspaces --all | head -n 10) )

for sid in "${sids[@]}"; do
    sketchybar --add item space.$sid center \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label.font="$FONT:Black:14.0" \
        label.color=0xff583794 \
        icon.font="$FONT:Black:14.0" \
        icon="$sid" \
        icon.color=0xff583794 \
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
done
