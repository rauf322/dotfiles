return {
    --Left side bar 
    font = {
        text = "SF Pro",
        numbers = "SF Pro",
        size = 14.0,
        style_map = {
            ["Regular"] = "Regular",
            ["Semibold"] = "Semibold",
            ["Bold"] = "Bold",
            ["Heavy"] = "Heavy",
            ["Black"] = "Black",
        },
    },
    --Right side bar
    font_icon = {
        text = "Nerd Font",
        numbers = "Nerd Font",
        size = 15.0,
        style_map = {
            ["Regular"] = "Regular",
            ["Semibold"] = "Semibold",
            ["Bold"] = "Bold",
            ["Heavy"] = "Heavy",
            ["Black"] = "Black",
        },
    },
    --Bar t
    height = 30,
    paddings = 8,
    group_paddings = 5,
    padding = {
        icon_item = {
            --icon left not !aerospace!
            icon = {
                padding_left = 12,
                padding_right = 12,
            },
        },
        icon_label_item = {
            --icon right not !calendar!
            icon = {
                padding_left = 12,
                padding_right = 0,
            },
            label = {
                padding_left = 12,
                padding_right = 8,
            }
        }
    }
}
