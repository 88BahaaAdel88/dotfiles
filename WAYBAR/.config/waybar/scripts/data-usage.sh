#!/bin/bash

WIFI="wlan0"
ETH="enp5s0f3u2"

get_data() {
    vnstat -i "$1" --oneline 2>/dev/null
}

WIFI_DATA=$(get_data "$WIFI")
ETH_DATA=$(get_data "$ETH")

# If neither interface is available
if [[ -z "$WIFI_DATA" && -z "$ETH_DATA" ]]; then
    echo '{"text":"󰤨 --","tooltip":"vnStat unavailable"}'
    exit 0
fi

DATE=$(date '+%Y-%m-%d')

# Get today's values
WIFI_DATE=$(echo "$WIFI_DATA" | cut -d';' -f3)
if [[ "$WIFI_DATE" == "$DATE" ]]; then
    WIFI_RX=$(echo "$WIFI_DATA" | cut -d';' -f4)
    WIFI_TX=$(echo "$WIFI_DATA" | cut -d';' -f5)
    WIFI_TOTAL=$(echo "$WIFI_DATA" | cut -d';' -f6)
else
    WIFI_RX="0 MiB"
    WIFI_TX="0 MiB"
    WIFI_TOTAL="0 MiB"
fi

ETH_DATE=$(echo "$ETH_DATA" | cut -d';' -f3)
if [[ "$ETH_DATE" == "$DATE" ]]; then
    ETH_RX=$(echo "$ETH_DATA" | cut -d';' -f4)
    ETH_TX=$(echo "$ETH_DATA" | cut -d';' -f5)
    ETH_TOTAL=$(echo "$ETH_DATA" | cut -d';' -f6)
else
    ETH_RX="0 MiB"
    ETH_TX="0 MiB"
    ETH_TOTAL="0 MiB"
fi

# Convert vnStat values to MiB
to_mib() {
    local value="$1"

    [[ -z "$value" ]] && echo "0" && return

    awk -v value="$value" '
    BEGIN {
        split(value, a, " ")
        number = a[1]
        unit = a[2]

        if (unit == "KiB")
            print number / 1024
        else if (unit == "MiB")
            print number
        else if (unit == "GiB")
            print number * 1024
        else if (unit == "TiB")
            print number * 1024 * 1024
        else
            print 0
    }'
}

WIFI_RX_MIB=$(to_mib "$WIFI_RX")
WIFI_TX_MIB=$(to_mib "$WIFI_TX")

ETH_RX_MIB=$(to_mib "$ETH_RX")
ETH_TX_MIB=$(to_mib "$ETH_TX")

TOTAL_RX=$(awk "BEGIN {print $WIFI_RX_MIB + $ETH_RX_MIB}")
TOTAL_TX=$(awk "BEGIN {print $WIFI_TX_MIB + $ETH_TX_MIB}")
TOTAL=$(awk "BEGIN {print $TOTAL_RX + $TOTAL_TX}")

# Format MiB nicely
format_size() {
    awk -v mib="$1" '
    BEGIN {
        if (mib >= 1024)
            printf "%.2f GiB", mib / 1024
        else
            printf "%.2f MiB", mib
    }'
}

TOTAL_RX=$(format_size "$TOTAL_RX")
TOTAL_TX=$(format_size "$TOTAL_TX")
TOTAL=$(format_size "$TOTAL")

echo "{\"text\":\"󰤨 $TOTAL\",\"tooltip\":\"Today ($DATE)\\n\\n󰍛 Total:    $TOTAL\\n󰁅 Download: $TOTAL_RX\\n󰁆 Upload:   $TOTAL_TX\\n\\n󰤨 Wi-Fi:    $WIFI_TOTAL\\n󰈀 Ethernet: $ETH_TOTAL\"}"
