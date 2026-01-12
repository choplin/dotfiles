#!/bin/bash

ACTION="$1"
TIMER_FILE="$HOME/.local/share/sketchybar/timer"
mkdir -p "$(dirname "$TIMER_FILE")"

# Close popup
sketchybar --set timer popup.drawing=off

start_timer() {
    local DURATION=$1
    local END_TIME=$(($(date +%s) + DURATION * 60))
    echo "running" > "$TIMER_FILE"
    echo "$END_TIME" >> "$TIMER_FILE"
    echo "$DURATION" >> "$TIMER_FILE"
    # Enable 1-second updates while timer is running
    sketchybar --set timer update_freq=1
}

case "$ACTION" in
    25|5|1)
        start_timer "$ACTION"
        ;;
    pause)
        END_TIME=$(sed -n '2p' "$TIMER_FILE" 2>/dev/null || echo "0")
        DURATION=$(sed -n '3p' "$TIMER_FILE" 2>/dev/null || echo "25")
        NOW=$(date +%s)
        REMAINING=$((END_TIME - NOW))
        [[ $REMAINING -lt 0 ]] && REMAINING=0
        echo "paused" > "$TIMER_FILE"
        echo "$REMAINING" >> "$TIMER_FILE"
        echo "$DURATION" >> "$TIMER_FILE"
        ;;
    resume)
        REMAINING=$(sed -n '2p' "$TIMER_FILE" 2>/dev/null || echo "0")
        DURATION=$(sed -n '3p' "$TIMER_FILE" 2>/dev/null || echo "25")
        END_TIME=$(($(date +%s) + REMAINING))
        echo "running" > "$TIMER_FILE"
        echo "$END_TIME" >> "$TIMER_FILE"
        echo "$DURATION" >> "$TIMER_FILE"
        ;;
    reset|skip)
        echo "idle" > "$TIMER_FILE"
        # Disable updates when idle
        sketchybar --set timer update_freq=0
        ;;
esac

sketchybar --trigger timer_update
