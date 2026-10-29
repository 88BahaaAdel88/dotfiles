------------------
---- MONITORS ----
------------------

-- Main laptop display at origin (0x0)
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})

-- Current external monitor matched by hardware EDID description
-- Placed to the left of the laptop regardless of changing port names (DP-1, DP-2, etc.)
hl.monitor({
    output   = "desc:Samsung Electric Company SMS22A450",
    mode     = "preferred",
    position = "auto-left",
    scale    = 1,
})

-- Fallback for all other connected displays (places to the right of the laptop)
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto-right",
    scale    = 1,
})

--------------------
---- WORKSPACES ----
--------------------

-- First 6 workspaces belong to Samsung monitor when connected
for i = 1, 6 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor   = "desc:Samsung Electric Company SMS22A450",
        default   = (i == 1),
    })
end

-- Remaining workspaces belong to the laptop display
for i = 7, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor   = "eDP-1",
    })
end
