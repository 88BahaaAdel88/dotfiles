#!/bin/bash

# Check if Bluetooth is powered on
bt_power=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [[ "$bt_power" == "yes" ]]; then
    connected=$(bluetoothctl info | grep "Name" | awk -F ': ' '{print $2}')
    if [[ -n "$connected" ]]; then
        echo "$connected"
    else
        echo "ON"
    fi
else
    echo "OFF"
fi
