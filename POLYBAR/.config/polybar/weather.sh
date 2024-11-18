#!/bin/bash
source ~/.config/polybar/.envv

CITY="361058"
URL="https://api.openweathermap.org/data/2.5/weather?id=${CITY}&appid=${API_KEY}&units=metric"

# Fetch weather data
weather_data=$(curl -s "$URL")

if [[ $? -ne 0 ]]; then
  echo "***"
  exit 1
fi

# jq
temp=$(echo "$weather_data" | jq '.main.temp' | xargs printf "%.1f")
condition=$(echo "$weather_data" | jq -r '.weather[0].description')
wind_speed=$(echo "$weather_data" | jq '.wind.speed' | xargs printf "%.1f")

#echo "Weather in $CITY:"
#echo "Temperature: ${temp}°C"
#echo "Condition: ${condition^}"
#echo "Wind Speed: ${wind_speed} m/s"

case "$condition" in
    "clear sky") icon="" ;;
    "few clouds") icon="" ;;
    "rain") icon="" ;;
    "light rain") icon= ;;
    *) icon="󰖚" ;;           # Default icon
esac

echo "$icon ${temp}°C"
