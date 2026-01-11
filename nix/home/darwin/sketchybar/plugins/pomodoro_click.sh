#!/bin/bash

POMO_DIR="$HOME/.local/share/sketchybar"
POMO_FILE="$POMO_DIR/pomodoro"
mkdir -p "$POMO_DIR"

STATE=$(cat "$POMO_FILE" 2>/dev/null | head -1 || echo "idle")

case "$STATE" in
  idle)
    # Start work session (25 min)
    END_TIME=$(($(date +%s) + 25 * 60))
    echo "work" > "$POMO_FILE"
    echo "$END_TIME" >> "$POMO_FILE"
    ;;
  work|break)
    # Stop/reset
    echo "idle" > "$POMO_FILE"
    ;;
esac

# Trigger update
sketchybar --trigger pomodoro_update
