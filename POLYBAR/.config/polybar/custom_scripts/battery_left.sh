
#!/bin/bash

# Get battery information using acpi
battery_info=$(acpi -b)

# Extract time remaining
remaining_time=$(echo "$battery_info" | grep -oP '\d{2}:\d{2}')

# Check if time is available
if [ -n "$remaining_time" ]; then
    echo "$remaining_time"
else
    echo "Battery is not discharging or no data available."
fi
