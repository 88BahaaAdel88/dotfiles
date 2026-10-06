#!/usr/bin/env bash

CACHE_FILE="/tmp/hyprlock_weather.cache"
CACHE_TTL=900 # 15 minutes cache

# Check if cache is fresh
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) ))
    if [ "$cache_age" -lt "$CACHE_TTL" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Fetch weather with strict 3 second timeout
raw=$(curl -s --max-time 3 "wttr.in?format=%C|%t|%l" 2>/dev/null)

# Fallback to cache if request failed or returned error page
if [ -z "$raw" ] || echo "$raw" | grep -qi "error\|unknown\|html\|500\|502\|503"; then
    if [ -f "$CACHE_FILE" ]; then
        cat "$CACHE_FILE"
    fi
    exit 0
fi

condition=$(echo "$raw" | cut -d"|" -f1 | xargs)
temp=$(echo "$raw" | cut -d"|" -f2 | tr -d "+" | xargs)
location=$(echo "$raw" | cut -d"|" -f3 | cut -d"," -f1 | xargs)

if [ -z "$temp" ] || [ -z "$location" ]; then
    if [ -f "$CACHE_FILE" ]; then
        cat "$CACHE_FILE"
    fi
    exit 0
fi

# Detect day/night for sun/moon icons
hour=$(date +%H)
is_night=0
if [ "$hour" -lt 6 ] || [ "$hour" -ge 19 ]; then
    is_night=1
fi

case "$(echo "$condition" | tr '[:upper:]' '[:lower:]')" in
    *clear*|*sunny*)
        if [ "$is_night" -eq 1 ]; then icon="󰖔"; else icon="󰖙"; fi ;;
    *partly*|*few*)
        if [ "$is_night" -eq 1 ]; then icon="󰼱"; else icon="󰖕"; fi ;;
    *cloud*|*overcast*) icon="󰖐" ;;
    *rain*|*drizzle*|*shower*) icon="󰖖" ;;
    *thunder*) icon="󰖓" ;;
    *snow*|*blizzard*|*sleet*) icon="󰖘" ;;
    *fog*|*mist*|*haze*) icon="󰖑" ;;
    *wind*) icon="󰖝" ;;
    *) icon="󰖐" ;;
esac

output="<span font_size=\"18pt\" foreground=\"#cba6f7\">$icon</span>  <b>$temp</b>\n<span font_size=\"11pt\" foreground=\"#a6adc8\">$location</span>"

echo -e "$output" > "$CACHE_FILE"
cat "$CACHE_FILE"
