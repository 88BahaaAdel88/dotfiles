#!/usr/bin/env python3
import os
import sys
import time
import json
import socket
import subprocess

DAEMON_BIN = "/opt/waypaper-engine/resources/waypaper-daemon"

def get_current_wallpaper():
    """Retrieve current wallpaper info from waypaper-daemon."""
    try:
        res = subprocess.run(
            [DAEMON_BIN, "wallpaper", "current"],
            capture_output=True,
            text=True,
            timeout=5
        )
        if res.returncode == 0:
            return json.loads(res.stdout)
    except Exception:
        pass
    return None

def sync_all_monitors():
    """Apply the active wallpaper across all connected displays."""
    data = get_current_wallpaper()
    if not data:
        return False
    
    img_id = data.get("image_id")
    if img_id is None:
        return False

    try:
        subprocess.run(
            [DAEMON_BIN, "wallpaper", "set", str(img_id), "--mode", "clone", "-m", "*"],
            capture_output=True,
            timeout=5
        )
        return True
    except Exception:
        return False

def wait_for_daemon(max_wait=30):
    """Wait until waypaper-daemon is up and responding."""
    start = time.time()
    while time.time() - start < max_wait:
        if get_current_wallpaper() is not None:
            return True
        time.sleep(1)
    return False

def main():
    # Avoid duplicate instances
    lock_file = f"/tmp/wallpaper-sync-{os.getuid()}.lock"
    try:
        import fcntl
        lock_fd = open(lock_file, "w")
        fcntl.flock(lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except Exception:
        # Another instance is already running
        sys.exit(0)

    # Initial sync on startup
    if wait_for_daemon():
        sync_all_monitors()

    # Get Hyprland event socket
    xdg_runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    his = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not his:
        # Fallback to searching runtime dir for hyprland instance
        hypr_dir = os.path.join(xdg_runtime, "hypr")
        if os.path.isdir(hypr_dir):
            instances = [d for d in os.listdir(hypr_dir) if os.path.exists(os.path.join(hypr_dir, d, ".socket2.sock"))]
            if instances:
                his = instances[0]

    if not his:
        sys.exit(1)

    sock_path = os.path.join(xdg_runtime, "hypr", his, ".socket2.sock")

    # Event loop listening to monitor hotplugs
    while True:
        try:
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
                s.connect(sock_path)
                buffer = ""
                while True:
                    data = s.recv(1024).decode("utf-8", errors="ignore")
                    if not data:
                        break
                    buffer += data
                    while "\n" in buffer:
                        line, buffer = buffer.split("\n", 1)
                        line = line.strip()
                        if line.startswith("monitoradded>>") or line.startswith("monitoraddedv2>>"):
                            # Wait briefly for display negotiation to settle
                            time.sleep(1.5)
                            sync_all_monitors()
        except Exception:
            time.sleep(3)

if __name__ == "__main__":
    main()
