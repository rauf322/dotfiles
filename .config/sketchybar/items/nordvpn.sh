browser_icon=(
    icon.font="Font Awesome 6 Brands:Regular:20"  # Font Awesome 6 Free:Solid font
    icon=""  # Font Awesome Chrome icon (fa-chrome)
    icon.padding_right=4
    icon.color=$BLUE  # Adjust the color as needed
    icon.y_offset=1
    label.drawing=off
    background.color=0xff252731
    background.height=33
    background.corner_radius=20
    script="$PLUGIN_DIR/nordvpn.sh"  # Replace with your script if needed
    click_script="open -a 'NordVPN'; $POPUP_OFF"  # Or any browser you want to open
)

sketchybar --add item browser_icon left \
           --set browser_icon "${browser_icon[@]}"
