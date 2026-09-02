#!/bin/bash

PIDFILE="/tmp/caffeine.pid"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    kill "$(cat "$PIDFILE")"
    rm "$PIDFILE"
    notify-send "☕ Caffeine" "Sleep and lock prevention disabled"
else
    systemd-inhibit \
        --what=idle:sleep \
        --who="Caffeine" \
        --why="Caffeine mode" \
        --mode=block \
        sleep infinity &

    echo $! > "$PIDFILE"

    notify-send "☕ Caffeine" "Sleep and lock prevention enabled"
fi
