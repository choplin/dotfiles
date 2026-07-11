#!/bin/bash

source "$(dirname "$0")/icons.sh"
source "$(dirname "$0")/colors.sh"

NAME="${NAME:-caffeinate}"
PIDFILE="/tmp/sketchybar_caffeinate.pid"

# Determine current mode from the tracked process (single source of truth).
# Read-only: all state mutation (including pidfile cleanup) happens in the
# click script under a lock, so the renderer never races with it. Identity is
# verified via the executable name (comm); a dead/reused PID reads as off.
MODE="off"
if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE" 2>/dev/null)"
    case "$(ps -o comm= -p "${PID:-0}" 2>/dev/null)" in
        */caffeinate | caffeinate)
            case "$(ps -o args= -p "$PID" 2>/dev/null)" in
                *-di*) MODE="di" ;;  # display + idle (screen stays on)
                *)     MODE="i"  ;;  # idle only (screen may sleep, system awake)
            esac ;;
    esac
fi

# Same orange hue, intensity via alpha: dimmer = less "caffeinated".
case "$MODE" in
    di) ICON_COLOR="$ORANGE"           ;;  # full orange: fully awake, screen on
    i)  ICON_COLOR="0x80${ORANGE#0xff}" ;;  # orange @ 50% alpha: awake, screen may sleep
    *)  ICON_COLOR="$COLOR_TEXT_DIM"    ;;  # dim grey: off
esac

sketchybar --set "$NAME" icon="$ICON_CAFFEINE" icon.color="$ICON_COLOR"
