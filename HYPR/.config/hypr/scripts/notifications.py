#!/usr/bin/env python3
import os
import sys
import json
import subprocess
from pathlib import Path

RUNTIME_DIR = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
CACHE_FILE = Path(RUNTIME_DIR) / "hyprlock_notifications.json"

APP_CONFIGS = {
    "discord": {"name": "Discord", "icon": "󰙯", "color": "#cba6f7"},
    "telegram": {"name": "Telegram", "icon": "", "color": "#74c7ec"},
    "whatsapp": {"name": "WhatsApp", "icon": "", "color": "#a6e3a1"},
    "ticktick": {"name": "TickTick", "icon": "󰄴", "color": "#89b4fa"},
    "spotify": {"name": "Spotify", "icon": "", "color": "#a6e3a1"},
    "slack": {"name": "Slack", "icon": "", "color": "#fab387"},
    "zen": {"name": "Zen", "icon": "󰖟", "color": "#89dceb"},
    "firefox": {"name": "Firefox", "icon": "", "color": "#fab387"},
    "chrome": {"name": "Chrome", "icon": "", "color": "#89dceb"},
    "chromium": {"name": "Chromium", "icon": "", "color": "#89dceb"},
    "brave": {"name": "Brave", "icon": "󰖟", "color": "#fab387"},
    "thunderbird": {"name": "Thunderbird", "icon": "󰇮", "color": "#89b4fa"},
    "mail": {"name": "Mail", "icon": "󰇮", "color": "#89b4fa"},
    "github": {"name": "GitHub", "icon": "", "color": "#cdd6f4"},
    "obsidian": {"name": "Obsidian", "icon": "󱓧", "color": "#cba6f7"},
    "qbittorrent": {"name": "qBittorrent", "icon": "󰇚", "color": "#89b4fa"},
    "steam": {"name": "Steam", "icon": "", "color": "#89b4fa"},
    "alacritty": {"name": "Terminal", "icon": "󰆍", "color": "#a6e3a1"},
    "kitty": {"name": "Terminal", "icon": "󰆍", "color": "#a6e3a1"},
    "foot": {"name": "Terminal", "icon": "󰆍", "color": "#a6e3a1"},
    "terminal": {"name": "Terminal", "icon": "󰆍", "color": "#a6e3a1"},
    "flameshot": {"name": "Flameshot", "icon": "󰹑", "color": "#f38ba8"},
    "copyq": {"name": "CopyQ", "icon": "󰅌", "color": "#89dceb"},
}

DEFAULT_CONFIG = {"name": "Notification", "icon": "󰂚", "color": "#cba6f7"}

def load_data():
    if not CACHE_FILE.exists():
        return []
    try:
        with open(CACHE_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
            return data if isinstance(data, list) else []
    except Exception:
        return []

def save_data(data):
    try:
        temp_file = CACHE_FILE.with_suffix(".tmp")
        with open(temp_file, "w", encoding="utf-8") as f:
            json.dump(data, f)
        temp_file.replace(CACHE_FILE)
    except Exception:
        pass

def resolve_app(app_name, desktop_entry):
    lookup = f"{desktop_entry or ''} {app_name or ''}".lower()
    for key, conf in APP_CONFIGS.items():
        if key in lookup:
            return key, conf
    return "default", DEFAULT_CONFIG

def add_notification(nid, app_name, desktop_entry):
    data = load_data()
    # Avoid duplicate id if present
    data = [item for item in data if str(item.get("id")) != str(nid)]
    key, conf = resolve_app(app_name, desktop_entry)
    data.append({
        "id": nid,
        "key": key,
        "app": app_name,
        "desktop": desktop_entry
    })
    save_data(data)

def get_swaync_count():
    try:
        res = subprocess.run(
            ["swaync-client", "-c"],
            capture_output=True,
            text=True,
            timeout=1
        )
        if res.returncode == 0:
            return int(res.stdout.strip())
    except Exception:
        pass
    return None

def render_icons():
    real_count = get_swaync_count()
    if real_count is not None and real_count <= 0:
        if CACHE_FILE.exists():
            try:
                CACHE_FILE.unlink()
            except Exception:
                pass
        return

    data = load_data()
    if real_count is not None and len(data) > real_count:
        data = data[-real_count:]
        save_data(data)

    # Group counts by key
    counts = {}
    for item in data:
        k = item.get("key", "default")
        counts[k] = counts.get(k, 0) + 1

    total_tracked = sum(counts.values())
    untracked = 0
    if real_count is not None and real_count > total_tracked:
        untracked = real_count - total_tracked

    if untracked > 0:
        counts["default"] = counts.get("default", 0) + untracked

    if not counts:
        return

    rendered_items = []
    # Sort so known apps appear first, default/bell appears last
    sorted_keys = sorted(counts.keys(), key=lambda x: (x == "default", x))
    for k in sorted_keys:
        cnt = counts[k]
        conf = APP_CONFIGS.get(k, DEFAULT_CONFIG)
        icon = conf["icon"]
        color = conf["color"]
        if cnt <= 1:
            item = f"<span foreground='{color}'>{icon}</span>"
        else:
            item = f"<span foreground='{color}'>{icon}</span> <small><span foreground='#f9e2af'><b>{cnt}</b></span></small>"
        rendered_items.append(item)

    if rendered_items:
        print("     ".join(rendered_items))

def main():
    if len(sys.argv) >= 2 and sys.argv[1] == "add":
        nid = sys.argv[2] if len(sys.argv) > 2 else "0"
        app = sys.argv[3] if len(sys.argv) > 3 else ""
        desktop = sys.argv[4] if len(sys.argv) > 4 else ""
        add_notification(nid, app, desktop)
    elif len(sys.argv) >= 2 and sys.argv[1] == "clear":
        if CACHE_FILE.exists():
            CACHE_FILE.unlink()
    else:
        render_icons()

if __name__ == "__main__":
    main()
