#!/usr/bin/env bash

# Check if playerctl is installed
if ! command -v playerctl >/dev/null 2>&1; then
    echo '{"text":"󰎆 No media","tooltip":"playerctl is not installed","class":"none"}'
    exit 0
fi

# Get player status (Playing, Paused, Stopped, or empty)
STATUS=$(playerctl status 2>/dev/null)

if [[ -z "$STATUS" ]]; then
    echo '{"text":"󰎆 No media","tooltip":"No media playing","class":"none"}'
    exit 0
fi

PLAYER=$(playerctl metadata --format '{{playerName}}' 2>/dev/null)
ARTIST=$(playerctl metadata --format '{{artist}}' 2>/dev/null)
TITLE=$(playerctl metadata --format '{{title}}' 2>/dev/null)
ALBUM=$(playerctl metadata --format '{{album}}' 2>/dev/null)

# Clean and format track title
if [[ -n "$ARTIST" && -n "$TITLE" ]]; then
    TRACK="$ARTIST - $TITLE"
elif [[ -n "$TITLE" ]]; then
    TRACK="$TITLE"
elif [[ -n "$ARTIST" ]]; then
    TRACK="$ARTIST"
else
    TRACK=""
fi

# Clean leading/trailing hyphens or whitespace
TRACK=$(echo "$TRACK" | sed -e 's/^[[:space:]-]*//' -e 's/[[:space:]-]*$//')

# Build tooltip
TOOLTIP_LINES=()
if [[ -n "$PLAYER" ]]; then
    TOOLTIP_LINES+=("Player: $PLAYER")
fi
TOOLTIP_LINES+=("Status: $STATUS")
if [[ -n "$TITLE" ]]; then
    TOOLTIP_LINES+=("Title: $TITLE")
fi
if [[ -n "$ARTIST" ]]; then
    TOOLTIP_LINES+=("Artist: $ARTIST")
fi
if [[ -n "$ALBUM" ]]; then
    TOOLTIP_LINES+=("Album: $ALBUM")
fi

TOOLTIP=$(printf "%s\n" "${TOOLTIP_LINES[@]}")

case "$STATUS" in
    "Playing")
        CLASS="playing"
        if [[ -n "$TRACK" ]]; then
            TEXT="󰐊 $TRACK"
        else
            TEXT="󰐊 Playing"
        fi
        ;;
    "Paused")
        CLASS="paused"
        if [[ -n "$TRACK" ]]; then
            TEXT="󰏤 Paused · $TRACK"
        else
            TEXT="󰏤 Paused"
        fi
        ;;
    "Stopped")
        CLASS="stopped"
        if [[ -n "$TRACK" ]]; then
            TEXT="󰓛 Stopped · $TRACK"
        else
            TEXT="󰓛 Stopped"
        fi
        ;;
    *)
        CLASS="none"
        TEXT="󰎆 No media"
        ;;
esac

jq -nc \
    --arg text "$TEXT" \
    --arg tooltip "$TOOLTIP" \
    --arg class "$CLASS" \
    '{"text": $text, "tooltip": $tooltip, "class": $class}'
