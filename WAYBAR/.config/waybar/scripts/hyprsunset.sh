#!/bin/bash

STATE="$HOME/.cache/hyprsunset-state"

mkdir -p "$(dirname "$STATE")"

# Your automatic profiles
get_auto_temp() {
    current_time=$(date +%H:%M)

    if [[ "$current_time" < "07:00" ]]; then
        echo 3500
    elif [[ "$current_time" < "18:00" ]]; then
        echo 6000
    elif [[ "$current_time" < "21:00" ]]; then
        echo 5000
    elif [[ "$current_time" < "23:00" ]]; then
        echo 4000
    else
        echo 3500
    fi
}

# Manual temperature
set_temp() {
    local temp="$1"

    hyprctl hyprsunset temperature "$temp" >/dev/null 2>&1
    echo "$temp" > "$STATE"
}

# Automatic mode
set_auto() {
    rm -f "$STATE"
    hyprctl hyprsunset temperature "$(get_auto_temp)" >/dev/null 2>&1
}

case "$1" in
    next)
        current=$(cat "$STATE" 2>/dev/null || get_auto_temp)

        case "$current" in
            6000) set_temp 5000 ;;
            5000) set_temp 4000 ;;
            4000) set_temp 3500 ;;
            3500) set_temp 6000 ;;
            *)    set_temp 6000 ;;
        esac
        ;;

    off)
        rm -f "$STATE"
        hyprctl hyprsunset identity >/dev/null 2>&1
        ;;

    auto)
        set_auto
        ;;

    *)
        if [[ -f "$STATE" ]]; then
            temp=$(cat "$STATE")
            echo "{\"text\":\"󰖔 ${temp}K\",\"class\":\"manual\"}"
        else
            temp=$(get_auto_temp)
            echo "{\"text\":\"󰖔 ${temp}K\",\"class\":\"auto\"}"
        fi
        ;;
esac
