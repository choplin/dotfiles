#!/bin/bash

source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/icons.sh"

# Handle mouse.exited.global: close popup
case "$SENDER" in
    mouse.exited.global)
        sketchybar --set timer popup.drawing=off
        exit 0
        ;;
esac

TIMER_FILE="$HOME/.local/share/sketchybar/timer"

if [[ ! -f "$TIMER_FILE" ]]; then
    sketchybar --set "$NAME" icon="$ICON_POMODORO" label="--:--" icon.color="$COLOR_TEXT_DIM"
    exit 0
fi

{ { read -r STATE; read -r END_TIME; read -r DURATION; } < "$TIMER_FILE"; } 2>/dev/null || {
    STATE="idle"; END_TIME="0"; DURATION="25"
}
NOW=$(date +%s)

case "$STATE" in
    running)
        REMAINING=$((END_TIME - NOW))
        if [[ $REMAINING -le 0 ]]; then
            # Timer done
            if [[ "$DURATION" == "25" ]]; then
                # 25 min pomodoro: switch to break
                BREAK_MINS=5
                END_TIME=$((NOW + BREAK_MINS * 60))
                echo "break" > "$TIMER_FILE"
                echo "$END_TIME" >> "$TIMER_FILE"
                echo "$BREAK_MINS" >> "$TIMER_FILE"
                osascript -e 'display notification "Time for a break!" with title "Timer"' 2>/dev/null || true
                pkill -x afplay 2>/dev/null
                afplay "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/Ringtones/Illuminate.m4r" &
                REMAINING=$((BREAK_MINS * 60))
                MINS=$((REMAINING / 60))
                SECS=$((REMAINING % 60))
                sketchybar --set "$NAME" icon="$ICON_BREAK" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="$COLOR_ACCENT"
            else
                # Other durations: just notify and reset
                echo "idle" > "$TIMER_FILE"
                sketchybar --set timer update_freq=0
                osascript -e 'display notification "Timer complete!" with title "Timer"' 2>/dev/null || true
                pkill -x afplay 2>/dev/null
                afplay "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/Ringtones/Illuminate.m4r" &
                sketchybar --set "$NAME" icon="$ICON_POMODORO" label="--:--" icon.color="$COLOR_TEXT_DIM"
            fi
        else
            MINS=$((REMAINING / 60))
            SECS=$((REMAINING % 60))
            sketchybar --set "$NAME" icon="$ICON_POMODORO" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="$COLOR_HIGH"
        fi
        ;;
    break)
        REMAINING=$((END_TIME - NOW))
        if [[ $REMAINING -le 0 ]]; then
            # Break done
            echo "idle" > "$TIMER_FILE"
            sketchybar --set timer update_freq=0
            osascript -e 'display notification "Break over!" with title "Timer"' 2>/dev/null || true
            pkill -x afplay 2>/dev/null
            afplay "/System/Library/PrivateFrameworks/ToneLibrary.framework/Versions/A/Resources/Ringtones/Illuminate.m4r" &
            sketchybar --set "$NAME" icon="$ICON_POMODORO" label="--:--" icon.color="$COLOR_TEXT_DIM"
        else
            MINS=$((REMAINING / 60))
            SECS=$((REMAINING % 60))
            sketchybar --set "$NAME" icon="$ICON_BREAK" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="$COLOR_ACCENT"
        fi
        ;;
    paused)
        { { read -r _; read -r REMAINING; } < "$TIMER_FILE"; } 2>/dev/null || REMAINING="0"
        MINS=$((REMAINING / 60))
        SECS=$((REMAINING % 60))
        sketchybar --set "$NAME" icon="$ICON_PAUSE" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="$COLOR_TEXT_DIM"
        ;;
    *)
        sketchybar --set "$NAME" icon="$ICON_POMODORO" label="--:--" icon.color="$COLOR_TEXT_DIM"
        ;;
esac
