#!/usr/bin/env bash

# Find battery device
bat="/sys/class/power_supply/BAT0"
if [ ! -d "$bat" ]; then
    bat=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
fi

# Exit silently if no battery exists
if [ -z "$bat" ] || [ ! -d "$bat" ]; then
    exit 0
fi

capacity=$(cat "$bat/capacity" 2>/dev/null)
status=$(cat "$bat/status" 2>/dev/null)

if [ -z "$capacity" ]; then
    exit 0
fi

# Choose appropriate icon based on status and capacity
if [ "$status" = "Charging" ]; then
    icon="󰂄"
elif [ "$capacity" -ge 95 ]; then
    icon="󰁹"
elif [ "$capacity" -ge 85 ]; then
    icon="󰂂"
elif [ "$capacity" -ge 75 ]; then
    icon="󰂁"
elif [ "$capacity" -ge 65 ]; then
    icon="󰂀"
elif [ "$capacity" -ge 55 ]; then
    icon="󰁾"
elif [ "$capacity" -ge 45 ]; then
    icon="󰁽"
elif [ "$capacity" -ge 35 ]; then
    icon="󰁼"
elif [ "$capacity" -ge 25 ]; then
    icon="󰁻"
elif [ "$capacity" -ge 15 ]; then
    icon="󰁺"
else
    icon="󰂎"
fi

# Format output (highlight in red if low and not charging)
if [ "$status" != "Charging" ] && [ "$capacity" -le 20 ]; then
    echo "<span foreground='#f38ba8'>$icon $capacity%</span>"
else
    echo "$icon $capacity%"
fi
