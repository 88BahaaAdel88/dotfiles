#!/usr/bin/env python3
import fcntl
import json
import os
import socket
import subprocess
import sys
import time

SAMSUNG_DESC = "Samsung Electric Company SMS22A450"

def run_command(cmd):
    """Run a shell command and return stdout."""
    try:
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=5)
        return res.stdout.strip()
    except Exception:
        return ""

def get_json(cmd):
    """Run a command and parse JSON output."""
    out = run_command(cmd)
    if not out:
        return None
    try:
        return json.loads(out)
    except Exception:
        return None

def sync_workspaces():
    """Ensure workspaces 1-6 are on the Samsung monitor (or fallback to eDP) and 7-10 on eDP."""
    monitors = get_json("hyprctl monitors -j")
    workspaces = get_json("hyprctl workspaces -j")

    if not monitors or not workspaces:
        return

    samsung_name = None
    edp_name = None

    for m in monitors:
        desc = m.get("description", "")
        name = m.get("name", "")
        if SAMSUNG_DESC in desc or "SMS22A450" in desc:
            samsung_name = name
        if name.startswith("eDP"):
            edp_name = name

    # Fallback to first non-Samsung display if eDP is named differently
    if not edp_name:
        for m in monitors:
            if m.get("name") != samsung_name:
                edp_name = m.get("name")
                break

    if samsung_name:
        # Samsung monitor is connected
        # Move any active workspaces 1-6 that are not on Samsung over to Samsung
        for w in workspaces:
            wid = w.get("id")
            wmon = w.get("monitor")
            if wid in range(1, 7) and wmon != samsung_name:
                run_command(f"hyprctl dispatch 'hl.dsp.workspace.move({{ workspace = {wid}, monitor = \"{samsung_name}\" }})'")
            elif wid in range(7, 11) and edp_name and wmon != edp_name:
                run_command(f"hyprctl dispatch 'hl.dsp.workspace.move({{ workspace = {wid}, monitor = \"{edp_name}\" }})'")

        # If laptop display currently shows one of 1-6, switch it to workspace 7
        if edp_name:
            for m in monitors:
                if m.get("name") == edp_name:
                    active_ws = m.get("activeWorkspace", {}).get("id")
                    if active_ws in range(1, 7):
                        run_command(f"hyprctl dispatch 'hl.dsp.focus({{ monitor = \"{edp_name}\" }})'")
                        run_command("hyprctl dispatch 'hl.dsp.focus({{ workspace = 7 }})'")
                        run_command(f"hyprctl dispatch 'hl.dsp.focus({{ monitor = \"{samsung_name}\" }})'")
                    break
    elif edp_name:
        # Samsung monitor is disconnected: ensure workspaces 1-6 are on laptop
        for w in workspaces:
            wid = w.get("id")
            wmon = w.get("monitor")
            if wid in range(1, 7) and wmon != edp_name:
                run_command(f"hyprctl dispatch 'hl.dsp.workspace.move({{ workspace = {wid}, monitor = \"{edp_name}\" }})'")

def main():
    # Avoid duplicate instances
    lock_file = f"/tmp/workspace-sync-{os.getuid()}.lock"
    try:
        lock_fd = open(lock_file, "w")
        fcntl.flock(lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except Exception:
        # Another instance is already running
        sys.exit(0)

    # Initial sync on startup
    sync_workspaces()

    # Get Hyprland event socket
    xdg_runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    his = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not his:
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
                        if (line.startswith("monitoradded>>") or
                            line.startswith("monitoraddedv2>>") or
                            line.startswith("monitorremoved>>") or
                            line.startswith("monitorremovedv2>>")):
                            # Wait briefly for display negotiation to settle
                            time.sleep(1.0)
                            sync_workspaces()
        except Exception:
            time.sleep(3)

if __name__ == "__main__":
    main()
