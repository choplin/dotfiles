#!/usr/bin/env bash
# Left-click cycles: off -> caffeinate -i -> caffeinate -di -> off.
#
# Clicks are serialized with an atomic mkdir lock so rapid clicks cannot
# interleave their kill/start steps and leak orphan caffeinate processes.
# Bouncing (dropping a click under heavy contention) is acceptable.
[[ "$BUTTON" == "right" ]] && exit 0

PIDFILE="/tmp/sketchybar_caffeinate.pid"
LOCKDIR="/tmp/sketchybar_caffeinate.lock"

# --- Acquire the lock: serialize concurrent clicks. Steal a lock left behind
#     by a crashed holder (older than 10s); debounce (drop) under >~3s contention.
tries=0
until mkdir "$LOCKDIR" 2>/dev/null; do
    age=$(( $(date +%s) - $(stat -f %m "$LOCKDIR" 2>/dev/null || echo 0) ))
    if [ "$age" -ge 10 ]; then
        rmdir "$LOCKDIR" 2>/dev/null   # stale lock: previous holder crashed
        continue
    fi
    tries=$((tries + 1))
    [ "$tries" -gt 30 ] && exit 0       # ~3s of contention: bounce, drop click
    sleep 0.1
done
trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT

# --- Determine the current (intended) mode from the pidfile, identity-checked.
current="off"
if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE" 2>/dev/null)"
    case "$(ps -o comm= -p "${PID:-0}" 2>/dev/null)" in
        */caffeinate | caffeinate)
            case "$(ps -o args= -p "$PID" 2>/dev/null)" in
                *-di*) current="di" ;;
                *)     current="i"  ;;
            esac ;;
    esac
fi

# --- Reconcile to a clean slate: kill every bare-signature caffeinate. Only
#     this toggle ever spawns `caffeinate -i` / `caffeinate -di` with no timeout
#     or command, so this also reaps any orphan left by a past crash/race.
#     External invocations (e.g. `caffeinate -i -t 300`) are anchored out.
pkill -f 'caffeinate -di$' 2>/dev/null
pkill -f 'caffeinate -i$'  2>/dev/null
rm -f "$PIDFILE"

# --- Advance to the next state and record its pid.
case "$current" in
    off) nohup caffeinate -i  >/dev/null 2>&1 & echo $! > "$PIDFILE" ;;
    i)   nohup caffeinate -di >/dev/null 2>&1 & echo $! > "$PIDFILE" ;;
    di)  : ;;  # cycled back to off (nothing left running)
esac

# --- Refresh the bar (read-only render; safe to call while holding the lock).
"$(dirname "$0")/caffeinate.sh"
