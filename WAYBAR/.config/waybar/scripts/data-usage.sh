#!/bin/bash

IFACE="wlan0"

DATA=$(vnstat -i "$IFACE" --json d 2>/dev/null)

RX=$(echo "$DATA" | jq -r '.interfaces[0].traffic.day[0].rx')
TX=$(echo "$DATA" | jq -r '.interfaces[0].traffic.day[0].tx')

if [[ "$RX" == "null" || "$TX" == "null" ]]; then
    echo '{"text":"󰤨 --","tooltip":"No traffic data available"}'
    exit 0
fi

TOTAL=$((RX + TX))

format_bytes() {
    local bytes=$1

    if (( bytes >= 1073741824 )); then
        awk "BEGIN {printf \"%.2f GB\", $bytes/1073741824}"
    elif (( bytes >= 1048576 )); then
        awk "BEGIN {printf \"%.1f MB\", $bytes/1048576}"
    else
        awk "BEGIN {printf \"%.0f KB\", $bytes/1024}"
    fi
}

RX_FORMAT=$(format_bytes "$RX")
TX_FORMAT=$(format_bytes "$TX")
TOTAL_FORMAT=$(format_bytes "$TOTAL")

echo "{\"text\":\"󰤨 $TOTAL_FORMAT\",\"tooltip\":\"Today\\n󰁅 Download: $RX_FORMAT\\n󰁆 Upload:   $TX_FORMAT\\n󰍛 Total:    $TOTAL_FORMAT\"}"
