#!/bin/bash

# Get current brightness level and maximum brightness
current_brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)

# Calculate the current brightness percentage
brightness_percentage=$((100 * current_brightness / max_brightness))

# Set the brightness using a percentage value if passed as an argument
if [ -n "$1" ]; then
  target_percentage=$1

  # Cap the brightness at 100%
  if [ "$target_percentage" -gt 100 ]; then
    target_percentage=100
  fi

  # Set the brightness
  brightnessctl set "$target_percentage"% > /dev/null
fi

# Print the current brightness percentage
echo "$brightness_percentage%"
