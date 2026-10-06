#!/usr/bin/env bash

STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)

if [[ -z "$STATUS" ]]; then
    echo '{"text":"󰍭","class":"muted","tooltip":"Microphone unavailable"}'
elif [[ "$STATUS" == *"[MUTED]"* || "$STATUS" == *"Volume: 0.00"* ]]; then
    echo '{"text":"󰍭","class":"muted","tooltip":"Microphone muted"}'
else
    echo '{"text":"󰍬","class":"active","tooltip":"Microphone enabled"}'
fi
