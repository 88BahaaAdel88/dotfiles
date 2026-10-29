----------------------
---- WINDOW RULES ----
----------------------

-- TickTick
hl.window_rule({
    match     = { class = "^(ticktick)$" },
    float     = true,
    size      = "900 800",
    center    = true,
    workspace = "special:ticktick",
})

hl.window_rule({
    match       = { class = "^(ticktick-floating-timer)$" },
    float       = true,
    pin         = true,
    border_size = 0,
})

-- Discord
hl.window_rule({
    match     = { class = "^(discord)$" },
    float     = true,
    size      = "900 900",
    center    = true,
    workspace = "special:discord",
})

-- CopyQ
hl.window_rule({
    match = { class = "^(com\\.github\\.hluk\\.copyq)$" },
    float = true,
    size  = "400 700",
    move  = "(monitor_w-window_w-20) 45",
})

-- TLauncher starter and dialogs
hl.window_rule({
    match  = { class = "^(by-gdev-Main)$" },
    float  = true,
    center = true,
})

-- Pipewire Control Center
hl.window_rule({
    match  = { class = "^(hyprpwcenter)$" },
    float  = true,
    size   = "850 600",
    center = true,
})

-- Opacity Rules (Active / Inactive)
hl.window_rule({
    match   = { class = "^(kitty)$" },
    opacity = "0.85 0.75",
})

hl.window_rule({
    match   = { class = "^(nemo)$" },
    opacity = "0.90 0.80",
})

hl.window_rule({
    match   = { class = "^(obsidian|md\\.obsidian\\.Obsidian)$" },
    opacity = "0.84 0.72",
})

hl.window_rule({
    match   = { class = "^(ticktick)$" },
    opacity = "0.84 0.72",
})

---------------------
---- LAYER RULES ----
---------------------

hl.layer_rule({
    match        = { namespace = "waybar.*" },
    blur         = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    match        = { namespace = "wofi" },
    blur         = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    match        = { namespace = "hyprlauncher" },
    blur         = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    match        = { namespace = "swaync-control-center" },
    blur         = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    match        = { namespace = "swaync-notification-window" },
    blur         = true,
    ignore_alpha = 0.1,
})

hl.layer_rule({
    match = { namespace = "logout_dialog" },
    blur  = true,
})
