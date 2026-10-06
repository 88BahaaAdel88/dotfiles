#!/usr/bin/env bash

# Check if playerctl is available
if ! command -v playerctl >/dev/null 2>&1; then
    exit 0
fi

status=$(playerctl status 2>/dev/null)
if [ -z "$status" ]; then
    exit 0
fi

action="${1:-info}"

case "$action" in
    prev)
        echo "󰒮"
        ;;
    next)
        echo "󰒭"
        ;;
    play)
        if [ "$status" = "Playing" ]; then
            echo "󰏤"
        else
            echo "󰐊"
        fi
        ;;
    info|*)
        artist=$(playerctl metadata --format "{{ artist }}" 2>/dev/null)
        title=$(playerctl metadata --format "{{ title }}" 2>/dev/null)

        if [ -n "$artist" ] && [ -n "$title" ]; then
            track="<b>$artist</b>  ·  $title"
        elif [ -n "$title" ]; then
            track="$title"
        elif [ -n "$artist" ]; then
            track="$artist"
        else
            exit 0
        fi

        # Clean up stray hyphens or whitespace
        track=$(echo "$track" | sed 's/^[[:space:]]*-[[:space:]]*//; s/[[:space:]]*-[[:space:]]*$//')

        # Truncate track title if too long
        if [ ${#track} -gt 55 ]; then
            track="${track:0:52}..."
        fi

        # Calculate progress bar if position and length are available
        pos=$(playerctl position 2>/dev/null | cut -d. -f1)
        len=$(playerctl metadata mpris:length 2>/dev/null | awk '{print int($1 / 1000000)}')

        bar_line=""
        if [ -n "$pos" ] && [ -n "$len" ] && [ "$len" -gt 0 ] && [ "$pos" -le "$len" ]; then
            pos_m=$(( pos / 60 ))
            pos_s=$(( pos % 60 ))
            len_m=$(( len / 60 ))
            len_s=$(( len % 60 ))
            pos_fmt=$(printf "%02d:%02d" $pos_m $pos_s)
            len_fmt=$(printf "%02d:%02d" $len_m $len_s)

            total_dots=12
            curr_dot=$(( pos * total_dots / len ))
            bar=""
            for i in $(seq 0 $((total_dots - 1))); do
                if [ $i -eq $curr_dot ]; then
                    bar="${bar}●"
                elif [ $i -lt $curr_dot ]; then
                    bar="${bar}━"
                else
                    bar="${bar}─"
                fi
            done
            bar_line="<span font_size='9pt' foreground='#a6adc8'>$pos_fmt  $bar  $len_fmt</span>"
        fi

        if [ -n "$bar_line" ]; then
            echo -e "$track\n$bar_line"
        else
            echo "$track"
        fi
        ;;
esac
