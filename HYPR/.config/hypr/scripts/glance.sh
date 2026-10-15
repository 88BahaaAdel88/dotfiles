#!/usr/bin/env python3
import subprocess
import re
import os

weather_str = ""
try:
    weather_script = os.path.expanduser("~/.config/hypr/scripts/weather.sh")
    w = subprocess.check_output([weather_script], timeout=2).decode().strip()
    lines = [line.strip() for line in w.split("\n") if line.strip()]
    if len(lines) >= 1:
        m_icon = re.search(r">([^<]+)</span>", lines[0])
        m_temp = re.search(r"<b>([^<]+)</b>", lines[0])
        city = ""
        if len(lines) >= 2:
            m_city = re.search(r">([^<]+)</span>", lines[1])
            if m_city:
                city = m_city.group(1)
        if m_icon and m_temp:
            icon = m_icon.group(1).strip()
            temp = m_temp.group(1).strip()
            if city:
                weather_str = f"<span foreground='#cba6f7'>{icon}</span>  {temp} {city}"
            else:
                weather_str = f"<span foreground='#cba6f7'>{icon}</span>  {temp}"
except Exception:
    pass

prayer_str = ""
try:
    prayer_script = os.path.expanduser("~/.config/hypr/scripts/prayer.sh")
    p = subprocess.check_output([prayer_script], timeout=2).decode().strip()
    if p:
        prayer_str = p
except Exception:
    pass

parts = [p for p in [weather_str, prayer_str] if p]
if parts:
    print("   <span foreground='#6c7086'>·</span>   ".join(parts))
