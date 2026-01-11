#!/bin/bash

source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/icons.sh"

POMO_FILE="$HOME/.local/share/sketchybar/pomodoro"

if [ ! -f "$POMO_FILE" ]; then
    sketchybar --set "$NAME" icon="$ICON_POMODORO" label="--:--" icon.color="$COLOR_TEXT_DIM"
    exit 0
fi

STATE=$(head -1 "$POMO_FILE" 2>/dev/null || echo "idle")
END_TIME=$(tail -1 "$POMO_FILE" 2>/dev/null || echo "0")
NOW=$(date +%s)

case "$STATE" in
    work)
        REMAINING=$((END_TIME - NOW))
        if [ "$REMAINING" -le 0 ]; then
            # Work done, start break (5 min)
            END_TIME=$((NOW + 5 * 60))
            echo "break" > "$POMO_FILE"
            echo "$END_TIME" >> "$POMO_FILE"
            osascript -e 'display notification "Time for a break!" with title "Pomodoro"' 2>/dev/null || true
            REMAINING=$((5 * 60))
            COLOR="$COLOR_ACCENT"
        else
            COLOR="$COLOR_HIGH"
        fi
        MINS=$((REMAINING / 60))
        SECS=$((REMAINING % 60))
        sketchybar --set "$NAME" icon="$ICON_POMODORO" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="$COLOR"
        ;;
    break)
        REMAINING=$((END_TIME - NOW))
        if [ "$REMAINING" -le 0 ]; then
            # Break done
            echo "idle" > "$POMO_FILE"
            osascript -e 'display notification "Break over! Ready to work?" with title "Pomodoro"' 2>/dev/null || true
            sketchybar --set "$NAME" icon="$ICON_POMODORO" label="--:--" icon.color="$COLOR_TEXT_DIM"
        else
            MINS=$((REMAINING / 60))
            SECS=$((REMAINING % 60))
            sketchybar --set "$NAME" icon="$ICON_POMODORO" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="$COLOR_ACCENT"
        fi
        ;;
    *)
        sketchybar --set "$NAME" icon="$ICON_POMODORO" label="--:--" icon.color="$COLOR_TEXT_DIM"
        ;;
esac
