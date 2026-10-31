---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local browser     = "zen-browser"
local fileManager = "nemo"
local menu        = "wofi --show drun"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- System controls
hl.bind(mainMod .. " + Q",            hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + S",    hl.dsp.exec_cmd("hyprlock & disown && systemctl suspend"))
hl.bind(mainMod .. " + SHIFT + Pause",hl.dsp.exec_cmd("hyprlock & disown && systemctl hibernate"))
hl.bind(mainMod .. " + SHIFT + R",    hl.dsp.reload_config())

-- Application shortcuts
hl.bind(mainMod .. " + Return",       hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B",            hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + BackSpace",    hl.dsp.exec_cmd(fileManager))
hl.bind("Print",                      hl.dsp.exec_cmd("hyprshot -m region -z -o ~/Pictures/Screenshots"))
hl.bind(mainMod .. " + Print",        hl.dsp.exec_cmd("hyprshot -m active -m output --clipboard-only"))
hl.bind(mainMod .. " + D",            hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + R",            hl.dsp.exec_cmd("hyprlauncher -t"))
hl.bind(mainMod .. " + SHIFT + X",    hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + N",            hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + comma",        hl.dsp.exec_cmd([[rofimoji --selector wofi --action copy --selector-args="--width 600 --height 450"]]))
hl.bind(mainMod .. " + SHIFT + B",    hl.dsp.exec_cmd("killall -SIGUSR1 waybar 2>/dev/null || pkill -SIGUSR1 waybar"))
hl.bind(mainMod .. " + W",            hl.dsp.exec_cmd("killall -SIGUSR1 waybar 2>/dev/null || pkill -SIGUSR1 waybar"))
hl.bind(mainMod .. " + O",            hl.dsp.exec_cmd("/home/bahaa/Projects/ticktick-timer/ticktick-timer/run.sh"))

-- Window states
hl.bind(mainMod .. " + V",            hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",            hl.dsp.window.pin())
hl.bind(mainMod .. " + SHIFT + P",    hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T",            hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F",            hl.dsp.window.fullscreen())

-- Focus movement (Vim keys)
hl.bind(mainMod .. " + H",            hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",            hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",            hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",            hl.dsp.focus({ direction = "down" }))

-- Focus movement (Arrow keys)
hl.bind(mainMod .. " + left",         hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",        hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",           hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",         hl.dsp.focus({ direction = "down" }))

-- Window movement
hl.bind(mainMod .. " + SHIFT + H",    hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L",    hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J",    hl.dsp.window.move({ direction = "down" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10 -- workspace 10 binds to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Special workspaces (Scratchpads)
hl.bind("CTRL + ALT + A",             hl.dsp.workspace.toggle_special("ticktick"))
hl.bind("CTRL + ALT + D",             hl.dsp.workspace.toggle_special("discord"))

-- Scripts & utilities
hl.bind(mainMod .. " + SHIFT + C",    hl.dsp.exec_cmd("~/.config/hypr/scripts/caffeine.sh"))
hl.bind(mainMod .. " + SHIFT + V",    hl.dsp.exec_cmd("copyq show"))

-- Mouse actions
hl.bind(mainMod .. " + mouse:272",    hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",    hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))

-- SwayOSD multimedia keys
hl.bind("XF86AudioRaiseVolume",       hl.dsp.exec_cmd("swayosd-client --output-volume raise"),       { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",       hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       { repeating = true, locked = true })
hl.bind("XF86AudioMute",              hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { repeating = true, locked = true })
hl.bind("XF86AudioMicMute",           hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp",        hl.dsp.exec_cmd("swayosd-client --brightness raise"),          { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown",      hl.dsp.exec_cmd("swayosd-client --brightness lower"),          { repeating = true, locked = true })
hl.bind("Caps_Lock",                  hl.dsp.exec_cmd("swayosd-client --caps-lock"))

-- Media playback (playerctl)
hl.bind("XF86AudioNext",              hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause",             hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",              hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",              hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
