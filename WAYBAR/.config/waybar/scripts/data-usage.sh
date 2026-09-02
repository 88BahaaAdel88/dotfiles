#!/bin/bash

IFACE="wlan0"

DATA=$(vnstat -i "$IFACE" --oneline 2>/dev/null)

if [[ -z "$DATA" ]]; then
    echo '{"text":"󰤨 --","tooltip":"vnStat unavailable"}'
    exit 0
fi

# vnStat --oneline fields:
# 3 = today's date
# 4 = RX today
# 5 = TX today
# 6 = total today

DATE=$(echo "$DATA" | cut -d';' -f3)
RX=$(echo "$DATA" | cut -d';' -f4)
TX=$(echo "$DATA" | cut -d';' -f5)
TOTAL=$(echo "$DATA" | cut -d';' -f6)

echo "{\"text\":\"󰤨 $TOTAL\",\"tooltip\":\"Today ($DATE)\\n󰁅 Download: $RX\\n󰁆 Upload:   $TX\\n󰍛 Total:    $TOTAL\"}"
