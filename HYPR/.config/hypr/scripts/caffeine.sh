#!/bin/bash

PIDFILE="/tmp/caffeine.pid"

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    kill "$(cat "$PIDFILE")"
    rm "$PIDFILE"
    notify-send "☕ Caffeine" "Sleep prevention disabled"
else
    systemd-inhibit --what=sleep --why="Caffeine mode" sleep infinity &
    echo $! > "$PIDFILE"
    notify-send "☕ Caffeine" "Sleep prevention enabled"
fi
