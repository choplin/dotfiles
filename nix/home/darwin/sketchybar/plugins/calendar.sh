#!/bin/bash

source "$(dirname "$0")/colors.sh"

# Right click: Open Calendar app
if [[ "$BUTTON" == "right" ]]; then
    open -a Calendar
    exit 0
fi

# Left click: Show today's events in popup
if [[ "$BUTTON" == "left" ]]; then
    TODAY=$(date +%Y-%m-%d)

    # Get today's events
    EVENTS=$(gcalcli agenda "$TODAY" "$TODAY 23:59" --nocolor --tsv 2>/dev/null | tail -n +2)

    # Update popup items (max 5)
    for i in 0 1 2 3 4; do
        LINE=$(echo "$EVENTS" | sed -n "$((i+1))p")
        if [[ -n "$LINE" ]]; then
            TIME=$(echo "$LINE" | cut -f2)
            TITLE=$(echo "$LINE" | cut -f5)
            # Truncate title if too long
            [[ ${#TITLE} -gt 20 ]] && TITLE="${TITLE:0:17}..."
            sketchybar --set calendar_menu_$i drawing=on label="$TIME $TITLE"
        else
            sketchybar --set calendar_menu_$i drawing=off
        fi
    done

    sketchybar --set calendar popup.drawing=toggle
    exit 0
fi
