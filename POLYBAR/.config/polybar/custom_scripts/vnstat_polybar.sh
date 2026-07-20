#!/bin/bash

INTERFACE="wlan0"

vnstat --oneline -i $INTERFACE | awk -F\; '{ print " : " $4 }'
