#!/bin/bash

TIMER_FILE="$HOME/.local/share/sketchybar/timer"
mkdir -p "$(dirname "$TIMER_FILE")"

STATE=$(head -1 "$TIMER_FILE" 2>/dev/null || echo "idle")

# Shift+left click: Reset (when running/paused)
if [[ "$BUTTON" == "left" && "$MODIFIER" == "shift" ]]; then
    if [[ "$STATE" == "running" || "$STATE" == "paused" ]]; then
        echo "idle" > "$TIMER_FILE"
        sketchybar --trigger timer_update
    fi
    exit 0
fi

# Left click behavior depends on state
if [[ "$BUTTON" == "left" ]]; then
    case "$STATE" in
        idle)
            # Show time selection popup
            sketchybar --set timer_menu_25 drawing=on \
                       --set timer_menu_5 drawing=on \
                       --set timer_menu_1 drawing=on \
                       --set timer_menu_pause drawing=off \
                       --set timer_menu_resume drawing=off \
                       --set timer_menu_reset drawing=off \
                       --set timer_menu_skip drawing=off
            sketchybar --set timer popup.drawing=toggle
            ;;
        running)
            # Direct pause
            END_TIME=$(sed -n '2p' "$TIMER_FILE" 2>/dev/null || echo "0")
            DURATION=$(sed -n '3p' "$TIMER_FILE" 2>/dev/null || echo "25")
            NOW=$(date +%s)
            REMAINING=$((END_TIME - NOW))
            [[ $REMAINING -lt 0 ]] && REMAINING=0
            echo "paused" > "$TIMER_FILE"
            echo "$REMAINING" >> "$TIMER_FILE"
            echo "$DURATION" >> "$TIMER_FILE"
            sketchybar --trigger timer_update
            ;;
        paused)
            # Direct resume
            REMAINING=$(sed -n '2p' "$TIMER_FILE" 2>/dev/null || echo "0")
            DURATION=$(sed -n '3p' "$TIMER_FILE" 2>/dev/null || echo "25")
            END_TIME=$(($(date +%s) + REMAINING))
            echo "running" > "$TIMER_FILE"
            echo "$END_TIME" >> "$TIMER_FILE"
            echo "$DURATION" >> "$TIMER_FILE"
            sketchybar --trigger timer_update
            ;;
        break)
            # Direct skip
            echo "idle" > "$TIMER_FILE"
            sketchybar --trigger timer_update
            ;;
    esac
    exit 0
fi

# Right click: context-sensitive action
if [[ "$BUTTON" == "right" ]]; then
    case "$STATE" in
        idle)
            # Show input dialog for custom duration
            MINS=$(osascript -e 'text returned of (display dialog "Enter minutes:" default answer "10")' 2>/dev/null)
            if [[ -n "$MINS" && "$MINS" =~ ^[0-9]+$ && "$MINS" -gt 0 ]]; then
                END_TIME=$(($(date +%s) + MINS * 60))
                echo "running" > "$TIMER_FILE"
                echo "$END_TIME" >> "$TIMER_FILE"
                echo "$MINS" >> "$TIMER_FILE"
                sketchybar --trigger timer_update
            fi
            ;;
        running)
            sketchybar --set timer_menu_25 drawing=off \
                       --set timer_menu_5 drawing=off \
                       --set timer_menu_1 drawing=off \
                       --set timer_menu_pause drawing=on \
                       --set timer_menu_resume drawing=off \
                       --set timer_menu_reset drawing=on \
                       --set timer_menu_skip drawing=off
            sketchybar --set timer popup.drawing=toggle
            ;;
        paused)
            sketchybar --set timer_menu_25 drawing=off \
                       --set timer_menu_5 drawing=off \
                       --set timer_menu_1 drawing=off \
                       --set timer_menu_pause drawing=off \
                       --set timer_menu_resume drawing=on \
                       --set timer_menu_reset drawing=on \
                       --set timer_menu_skip drawing=off
            sketchybar --set timer popup.drawing=toggle
            ;;
        break)
            sketchybar --set timer_menu_25 drawing=off \
                       --set timer_menu_5 drawing=off \
                       --set timer_menu_1 drawing=off \
                       --set timer_menu_pause drawing=off \
                       --set timer_menu_resume drawing=off \
                       --set timer_menu_reset drawing=off \
                       --set timer_menu_skip drawing=on
            sketchybar --set timer popup.drawing=toggle
            ;;
    esac
    exit 0
fi
