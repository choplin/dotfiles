#!/usr/bin/env bash
# Left-click cycles: off -> caffeinate -i -> caffeinate -di -> off
[[ "$BUTTON" == "right" ]] && exit 0

PIDFILE="/tmp/sketchybar_caffeinate.pid"

# Read current mode from the tracked process, confirming identity via the
# executable name (comm) so a reused PID after reboot is never killed.
current="off"
is_ours=""
if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE" 2>/dev/null)"
    case "$(ps -o comm= -p "${PID:-0}" 2>/dev/null)" in
        */caffeinate | caffeinate)
            is_ours=1
            case "$(ps -o args= -p "$PID" 2>/dev/null)" in
                *-di*) current="di" ;;
                *)     current="i"  ;;
            esac ;;
    esac
fi

# Stop our running instance (only if the PID is genuinely our caffeinate).
[ -n "$is_ours" ] && kill "$PID" 2>/dev/null
rm -f "$PIDFILE"

# Advance to the next state.
case "$current" in
    off) nohup caffeinate -i  >/dev/null 2>&1 & echo $! > "$PIDFILE" ;;
    i)   nohup caffeinate -di >/dev/null 2>&1 & echo $! > "$PIDFILE" ;;
    di)  : ;;  # cycled back to off (already stopped above)
esac

# Refresh the bar immediately.
"$(dirname "$0")/caffeinate.sh"
