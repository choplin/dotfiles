#!/bin/bash

source "$(dirname "$0")/icons.sh"

STATE=$(echo "$INFO" | jq -r '.state // empty')
APP=$(echo "$INFO" | jq -r '.app // empty')

if [ "$STATE" = "playing" ]; then
    ARTIST=$(echo "$INFO" | jq -r '.artist // empty')
    TITLE=$(echo "$INFO" | jq -r '.title // empty')

    # Truncate if too long
    if [ ${#TITLE} -gt 30 ]; then
        TITLE="${TITLE:0:27}..."
    fi

    if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        sketchybar --set "$NAME" label="$ARTIST - $TITLE" icon="$ICON_PLAY" drawing=on
    else
        sketchybar --set "$NAME" drawing=off
    fi
else
    sketchybar --set "$NAME" drawing=off
fi
