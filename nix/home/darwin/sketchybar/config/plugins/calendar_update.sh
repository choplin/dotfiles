#!/bin/bash

source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/icons.sh"

# Handle mouse.exited.global: close popup
case "$SENDER" in
    mouse.exited.global)
        sketchybar --set calendar popup.drawing=off
        exit 0
        ;;
esac

# Cache settings
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar"
mkdir -p "$CACHE_DIR"
CACHE_FILE="$CACHE_DIR/calendar"
CACHE_TTL=60

NOW_EPOCH=$(date +%s)
NOW_HM=$(date +%H:%M)
TODAY=$(date +%Y-%m-%d)

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

# Filter for next event
NEXT_LINE=$(echo "$EVENTS" | awk -F'\t' -v now="$NOW_HM" '
    $2 >= now {
        print $2 "\t" $5
        exit
    }
')

if [[ -z "$NEXT_LINE" ]]; then
    sketchybar --set "$NAME" icon="$ICON_CALENDAR" label="No events" icon.color="$COLOR_TEXT_DIM"
    exit 0
fi

EVENT_TIME=$(echo "$NEXT_LINE" | cut -f1)
EVENT_TITLE=$(echo "$NEXT_LINE" | cut -f2)

# Calculate minutes until event
EVENT_EPOCH=$(date -j -f "%Y-%m-%d %H:%M" "$TODAY $EVENT_TIME" +%s 2>/dev/null)
MINS_UNTIL=$(( (EVENT_EPOCH - NOW_EPOCH) / 60 ))

# Only show if within 60 minutes
if [[ $MINS_UNTIL -gt 60 ]]; then
    sketchybar --set "$NAME" icon="$ICON_CALENDAR" label="No events" icon.color="$COLOR_TEXT_DIM"
    exit 0
fi

# Truncate title if needed to fit "Title in XXm" in 25 chars
SUFFIX=" in ${MINS_UNTIL}m"
MAX_TITLE=$((25 - ${#SUFFIX}))
if [[ ${#EVENT_TITLE} -gt $MAX_TITLE ]]; then
    EVENT_TITLE="${EVENT_TITLE:0:$((MAX_TITLE - 3))}..."
fi
LABEL="$EVENT_TITLE$SUFFIX"

sketchybar --set "$NAME" icon="$ICON_CALENDAR" label="$LABEL" icon.color="$COLOR_TEXT"
