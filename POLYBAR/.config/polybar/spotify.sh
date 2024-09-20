
#!/bin/bash
# spotify-script.sh

# Check if Spotify is running
if pgrep -x "spotify" > /dev/null; then
    # Get the current song playing
    output=$(playerctl --player=spotify metadata --format "{{ artist }} - {{ title }}")
    echo "$output"
else
    echo "Spotify is not running"
fi
