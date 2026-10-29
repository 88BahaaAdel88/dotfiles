-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    -- Set cursor theme and size
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

    -- Core daemons & tools
    hl.exec_cmd("waybar & swaync & hypridle & hyprpaper")
    hl.exec_cmd("hyprlauncher -d")

    -- Polkit Authentication Agent
    hl.exec_cmd("systemctl --user start hyprpolkitagent || /usr/lib/hyprpolkitagent/hyprpolkitagent")

    -- Utility & background apps
    hl.exec_cmd("ticktick")
    hl.exec_cmd("copyq")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("waypaper-engine")
    hl.exec_cmd("python3 ~/.config/hypr/scripts/wallpaper-sync.py")
    hl.exec_cmd("python3 ~/.config/hypr/scripts/workspace-sync.py")
    hl.exec_cmd("discord")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("/home/bahaa/Projects/ticktick-timer/ticktick-timer/run.sh")
end)
