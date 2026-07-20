#!/bin/bash

# Network interface (change if needed, e.g., enp3s0, eth0, wlan0)
INTERFACE="wlp2s0"

# Get RX/TX data using /sys/class/net (no need for external tools)
RX_BYTES_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_BYTES_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
sleep 1
RX_BYTES_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX_BYTES_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

RX_RATE=$(( ($RX_BYTES_AFTER - $RX_BYTES_BEFORE) / 1024 ))
TX_RATE=$(( ($TX_BYTES_AFTER - $TX_BYTES_BEFORE) / 1024 ))

echo " ${RX_RATE}KB/s  ${TX_RATE}KB/s"
