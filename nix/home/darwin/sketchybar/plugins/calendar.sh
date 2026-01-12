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

    # Cache settings
    CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar"
    mkdir -p "$CACHE_DIR"
    CACHE_FILE="$CACHE_DIR/calendar"
    CACHE_TTL=60
    NOW_EPOCH=$(date +%s)

    # Check cache validity
    EVENTS=""
    if [[ -f "$CACHE_FILE" ]]; then
        CACHE_AGE=$((NOW_EPOCH - $(stat -f %m "$CACHE_FILE")))
        if [[ $CACHE_AGE -lt $CACHE_TTL ]]; then
            EVENTS=$(cat "$CACHE_FILE")
        fi
    fi

    # Fetch if cache miss/expired
    if [[ -z "$EVENTS" ]]; then
        EVENTS=$(gcalcli agenda "$TODAY" "$TODAY 23:59" --nocolor --tsv 2>/dev/null | tail -n +2)
        echo "$EVENTS" > "$CACHE_FILE"
    fi

    # Update popup items (max 5) using while loop instead of sed/cut in loop
    i=0
    while IFS=$'\t' read -r DATE TIME END_TIME _ TITLE _; do
        if [[ $i -ge 5 ]]; then
            break
        fi
        if [[ -n "$TIME" ]]; then
            # Truncate title if too long
            [[ ${#TITLE} -gt 20 ]] && TITLE="${TITLE:0:17}..."
            sketchybar --set "calendar_menu_$i" drawing=on label="$TIME $TITLE"
        else
            sketchybar --set "calendar_menu_$i" drawing=off
        fi
        ((i++))
    done <<< "$EVENTS"

    # Hide remaining items
    while [[ $i -lt 5 ]]; do
        sketchybar --set "calendar_menu_$i" drawing=off
        ((i++))
    done

    sketchybar --set calendar popup.drawing=toggle
    exit 0
fi
