#!/bin/bash

source "$(dirname "$0")/icons.sh"
source "$(dirname "$0")/colors.sh"

NAME="${NAME:-caffeinate}"
PIDFILE="/tmp/sketchybar_caffeinate.pid"

# Determine current mode from the tracked process (single source of truth).
# Verify identity via the executable name (comm) so a reused PID reads as off,
# then read the mode from the args (-i vs -di).
MODE="off"
if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE" 2>/dev/null)"
    case "$(ps -o comm= -p "${PID:-0}" 2>/dev/null)" in
        */caffeinate | caffeinate)
            case "$(ps -o args= -p "$PID" 2>/dev/null)" in
                *-di*) MODE="di" ;;  # display + idle (screen stays on)
                *)     MODE="i"  ;;  # idle only (screen may sleep, system awake)
            esac ;;
        *) rm -f "$PIDFILE" ;;       # dead or PID reused by another process
    esac
fi

# Same orange hue, intensity via alpha: dimmer = less "caffeinated".
case "$MODE" in
    di) ICON_COLOR="$ORANGE"           ;;  # full orange: fully awake, screen on
    i)  ICON_COLOR="0x80${ORANGE#0xff}" ;;  # orange @ 50% alpha: awake, screen may sleep
    *)  ICON_COLOR="$COLOR_TEXT_DIM"    ;;  # dim grey: off
esac

sketchybar --set "$NAME" icon="$ICON_CAFFEINE" icon.color="$ICON_COLOR"
