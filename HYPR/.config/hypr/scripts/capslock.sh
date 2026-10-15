#!/usr/bin/env bash

# Fast check via sysfs leds (0.3ms, no subprocesses)
for f in /sys/class/leds/*capslock*/brightness; do
    [ -f "$f" ] || continue
    read -r val < "$f" 2>/dev/null
    if [ "$val" = "1" ]; then
        echo "󰪛 Caps Lock is ON"
        exit 0
    fi
done

# Fallback: hyprctl in case no sysfs LED node exists
if command -v hyprctl &>/dev/null; then
    if hyprctl devices -j 2>/dev/null | grep -q '"capsLock": true'; then
        echo "󰪛 Caps Lock is ON"
        exit 0
    fi
fi

# Caps Lock is OFF
exit 0
