#!/usr/bin/env python3
import os
import json
import datetime
import urllib.request
import math

CACHE_FILE = f"/tmp/hyprlock_prayer_{datetime.date.today()}.json"

def calculate_times(date_obj):
    """Offline astronomical calculation fallback (Egyptian Survey Authority)."""
    LAT = 31.2001
    LON = 29.9187
    FAJR_A = 19.5
    ISHA_A = 17.5

    def dsin(x): return math.sin(math.radians(x))
    def dcos(x): return math.cos(math.radians(x))
    def dtan(x): return math.tan(math.radians(x))
    def darccos(x): return math.degrees(math.acos(x))
    def darctan2(y, x): return math.degrees(math.atan2(y, x))
    def fix_h(a): return a - 24.0 * math.floor(a / 24.0)
    def fix_a(a): return a - 360.0 * math.floor(a / 360.0)

    y, m, d = date_obj.year, date_obj.month, date_obj.day
    if m <= 2:
        y -= 1
        m += 12
    A = math.floor(y / 100)
    B = 2 - A + math.floor(A / 4)
    JD = math.floor(365.25 * (y + 4716)) + math.floor(30.6001 * (m + 1)) + d + B - 1524.5
    d_val = JD - 2451545.0
    g = fix_a(357.529 + 0.98560028 * d_val)
    q = fix_a(280.459 + 0.98564736 * d_val)
    L = fix_a(q + 1.915 * dsin(g) + 0.020 * dsin(2 * g))
    e = 23.439 - 0.00000036 * d_val
    RA = fix_h(darctan2(dcos(e) * dsin(L), dcos(L)) / 15.0)
    decl = math.degrees(math.asin(dsin(e) * dsin(L)))
    EqT = (q / 15.0) - RA

    tz = datetime.datetime.now().astimezone().utcoffset().total_seconds() / 3600.0
    noon = fix_h(12 + tz - (LON / 15.0) - EqT)

    def sun_h(angle, dir=1):
        cos_v = (-dsin(angle) - dsin(LAT) * dsin(decl)) / (dcos(LAT) * dcos(decl))
        if cos_v > 1 or cos_v < -1:
            return None
        return noon + (dir * darccos(cos_v) / 15.0)

    def asr_h():
        t0 = math.radians(abs(LAT - decl))
        alt = math.degrees(math.atan(1.0 / (1.0 + math.tan(t0))))
        cos_v = (dsin(alt) - dsin(LAT) * dsin(decl)) / (dcos(LAT) * dcos(decl))
        return noon + (darccos(cos_v) / 15.0)

    def fmt(h):
        sec = round(h * 3600)
        return f"{(sec // 3600) % 24:02d}:{(sec // 60) % 60:02d}"

    return {
        "Fajr": fmt(sun_h(FAJR_A, -1)),
        "Dhuhr": fmt(noon),
        "Asr": fmt(asr_h()),
        "Maghrib": fmt(sun_h(0.833, 1)),
        "Isha": fmt(sun_h(ISHA_A, 1)),
    }

def get_timings():
    # 1. Read today's cache if available
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, "r") as f:
                data = json.load(f)
                if data and "Fajr" in data:
                    return data
        except Exception:
            pass

    # 2. Try fetching from official AlAdhan API
    url = "https://api.aladhan.com/v1/timingsByCity?city=Alexandria&country=Egypt&method=5"
    req = urllib.request.Request(url, headers={"User-Agent": "hyprlock/1.0"})
    try:
        with urllib.request.urlopen(req, timeout=3) as resp:
            data = json.loads(resp.read().decode())
            timings = data["data"]["timings"]
            with open(CACHE_FILE, "w") as f:
                json.dump(timings, f)
            return timings
    except Exception:
        pass

    # 3. Fallback to offline calculation
    calc = calculate_times(datetime.date.today())
    try:
        with open(CACHE_FILE, "w") as f:
            json.dump(calc, f)
    except Exception:
        pass
    return calc

def main():
    timings = get_timings()
    if not timings:
        return

    prayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
    now = datetime.datetime.now()
    today = now.date()

    prayer_times = []
    for p in prayers:
        t_str = timings.get(p)
        if not t_str:
            continue
        h, m = map(int, t_str.split(":")[:2])
        dt = datetime.datetime(today.year, today.month, today.day, h, m)
        prayer_times.append((p, dt))

    next_prayer = None
    for p, dt in prayer_times:
        if dt > now:
            next_prayer = (p, dt)
            break

    if not next_prayer:
        # After Isha: next prayer is tomorrow's Fajr
        fajr_str = timings.get("Fajr", "05:00")
        h, m = map(int, fajr_str.split(":")[:2])
        tomorrow = today + datetime.timedelta(days=1)
        next_prayer = ("Fajr", datetime.datetime(tomorrow.year, tomorrow.month, tomorrow.day, h, m))

    name, target_dt = next_prayer
    diff = target_dt - now
    total_minutes = int(diff.total_seconds() // 60)
    hours = total_minutes // 60
    mins = total_minutes % 60

    if hours > 0:
        cd = f"{hours}h {mins}m"
    else:
        cd = f"{mins}m"

    icon = "🕌"
    print(f"<span foreground='#cba6f7'>{icon}</span>  <b>{name}</b> in {cd}")

if __name__ == "__main__":
    main()
