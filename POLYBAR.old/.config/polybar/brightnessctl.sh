#!/bin/bash

# Set the brightness using a percentage value if passed as an argument
if [ -n "$1" ]; then
  # Cap the brightness at 100%
  target_percentage=$(( $1 > 100 ? 100 : $1 ))

  # Set the brightness
  brightnessctl set "$target_percentage"% > /dev/null
fi

# Print the current brightness percentage
current_brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percentage=$((100 * current_brightness / max_brightness))
echo "$brightness_percentage%"
