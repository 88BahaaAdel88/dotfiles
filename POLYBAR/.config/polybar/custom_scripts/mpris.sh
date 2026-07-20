#!/bin/bash

# Icon to prefix
icon=""  # Music note from Font Awesome

# Get metadata
status=$(playerctl status 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

# Exit quietly if no player
if [[ "$status" != "Playing" && "$status" != "Paused" ]]; then
    echo ""
    exit 0
fi

# Combine title
output="${artist} - ${title}"

# Trim long text
max_length=15
if [ ${#output} -gt $max_length ]; then
    output="${output:0:$max_length}…"
fi

# Show icon + trimmed title
echo "$icon $output"
