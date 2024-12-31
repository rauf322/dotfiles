#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set space.$1 \
               background.drawing=off \
               icon.font="Pacman-Dots:Regular:16º.0" \
               icon="" \
               icon.color=0xffeed49f \
               label.drawing=off
else
    sketchybar --set space.$1 \
               background.drawing=off \
               icon="$sid" \
               label="$1" \
               label.drawing=on
fi
