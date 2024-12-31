#!/bin/bash

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

apple_logo=(
  background.image="~/.config/sketchybar/assets/arch.png"
  background.image.scale=0.02
  background.drawing=on
  padding_left=10
  label.drawing=off
  click_script="$POPUP_CLICK_SCRIPT"
)

apple_prefs=(
  icon=􀺽
  label="Preferences"
  click_script="open -a 'System Preferences'; $POPUP_OFF"
)

apple_activity=(
  icon=􀒓
  label="Activity"
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
  icon=􀒳
  label="Lock Screen"
  click_script="open -a ScreenSaverEngine; $POPUP_OFF"
)


sketchybar --add item apple.logo left                  \
           --set apple.logo "${apple_logo[@]}"         \
                                                       \
           --add item apple.prefs popup.apple.logo     \
           --set apple.prefs "${apple_prefs[@]}"       \
                                                       \
           --add item apple.activity popup.apple.logo  \
           --set apple.activity "${apple_activity[@]}" \
                                                       \
           --add item apple.lock popup.apple.logo      \
           --set apple.lock "${apple_lock[@]}"

sketchybar --add item           seperator left                                           \
           --set seperator      background.image="~/.config/sketchybar/assets/seperator.png" \
                                background.image.scale=0.09 \
                                background.drawing=on   \
                                background.padding_left=12\
                                background.padding_right=3\
                                click_script="sketchybar --reload; $POPUP_OFF"
