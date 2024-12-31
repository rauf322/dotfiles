#!/bin/sh

sketchybar --add item weather right \
            --set weather \
            --set weather update_freq=1500\
            icon=󰖐 \
            label.font="$FONT:Black:13.0"\
            script="$PLUGIN_DIR/weather.sh" \
            --subscribe weather mouse.clicked

