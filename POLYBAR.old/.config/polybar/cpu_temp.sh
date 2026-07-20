#!/bin/bash

# Fetch the CPU temperature
temp=$(sensors | grep 'CPU:' | awk '{print $2}' | sed 's/+//g' | sed 's/°C//g')

# Display the temperature with an icon
echo " $temp°C"
