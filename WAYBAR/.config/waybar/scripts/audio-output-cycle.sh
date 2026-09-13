#!/bin/bash

# Get the sink IDs from the Sinks section
mapfile -t SINKS < <(
    wpctl status | awk '
        /Sinks:/ { in_sinks=1; next }
        /Sources:/ { if (in_sinks) exit }
        in_sinks && /^[[:space:]]*│?[[:space:]]*\*?[[:space:]]*[0-9]+\./ {
            line=$0
            sub(/^[^0-9]*/, "", line)
            match(line, /^[0-9]+/)
            print substr(line, RSTART, RLENGTH)
        }
    '
)

# We need at least two sinks
if [ "${#SINKS[@]}" -lt 2 ]; then
    exit 1
fi

# Find which sink is currently default
CURRENT=$(wpctl status | awk '
    /Sinks:/ { in_sinks=1; next }
    /Sources:/ { if (in_sinks) exit }
    in_sinks && /\*/ {
        line=$0
        sub(/^[^0-9]*/, "", line)
        match(line, /^[0-9]+/)
        print substr(line, RSTART, RLENGTH)
        exit
    }
')

# Find current sink index
CURRENT_INDEX=0

for i in "${!SINKS[@]}"; do
    if [ "${SINKS[$i]}" = "$CURRENT" ]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Select next sink
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#SINKS[@]} ))
NEXT="${SINKS[$NEXT_INDEX]}"

# Set it as default
wpctl set-default "$NEXT"
