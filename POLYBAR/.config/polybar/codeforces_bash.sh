#!/bin/bash

# Variables
USERNAME="b4haa7"
API_URL="https://codeforces.com/api/user.status?handle=$USERNAME"

# Fetch data
response=$(curl -s "$API_URL")

# Check for API response
if echo "$response" | jq -e .status | grep -q "OK"; then
    # Count unique solved problems
    solved_count=$(echo "$response" | jq '[.result[] | select(.verdict == "OK") | .problem.name] | unique | length')

    # Calculate streak
    today=$(date +%s)
    today_start=$(date -d "$(date +%Y-%m-%d) 00:00:00" +%s)
    streak=$(echo "$response" | jq --argjson today_start "$today_start" '
        [.result[] | select(.verdict == "OK" and (.creationTimeSeconds | tonumber) >= $today_start)] | length
    ')

    # Output results
    echo "$streak 󰈸"

else
    echo "*** 󰈸"
fi
