#!/bin/bash

# Background script to stream media updates to sketchybar
# Run this as a background process (via launchd)

PATH="/opt/homebrew/bin:$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"

ICON_MUSIC="󰝚"

# State variables (kept in memory)
SAVED_ARTIST=""
SAVED_TITLE=""

update_media() {
    local PLAYING="$1"
    local ARTIST="$2"
    local TITLE="$3"

    if [ "$PLAYING" = "true" ] && [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        if [ ${#TITLE} -gt 30 ]; then
            TITLE="${TITLE:0:27}..."
        fi
        sketchybar --set media label="$ARTIST - $TITLE" icon="$ICON_MUSIC" drawing=on
    else
        sketchybar --set media drawing=off
    fi
}

# Initial state from get command
INIT=$(media-control get 2>/dev/null)
if [ -n "$INIT" ]; then
    read -r PLAYING ARTIST TITLE <<< "$(echo "$INIT" | jq -r '[
        (if has("playing") then (.playing | tostring) else "false" end),
        (.artist // ""),
        (.title // "")
    ] | @tsv')"
    if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        SAVED_ARTIST="$ARTIST"
        SAVED_TITLE="$TITLE"
    fi
    update_media "$PLAYING" "$ARTIST" "$TITLE"
fi

# Stream updates (process substitution avoids subshell, preserving variables)
while IFS= read -r line; do
    read -r PLAYING ARTIST TITLE <<< "$(echo "$line" | jq -r '[
        (if .payload | has("playing") then (.payload.playing | tostring) else "null" end),
        (.payload.artist // ""),
        (.payload.title // "")
    ] | @tsv')"

    # Skip empty events (no playing status)
    if [ "$PLAYING" = "null" ]; then
        continue
    fi

    # Empty artist/title handling
    if [ -z "$ARTIST" ] && [ -z "$TITLE" ]; then
        if [ "$PLAYING" = "false" ]; then
            sketchybar --set media drawing=off
            continue
        fi
        # Use saved values for resume
        ARTIST="$SAVED_ARTIST"
        TITLE="$SAVED_TITLE"
    elif [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        # Update saved values
        SAVED_ARTIST="$ARTIST"
        SAVED_TITLE="$TITLE"
    fi

    update_media "$PLAYING" "$ARTIST" "$TITLE"
done < <(media-control stream 2>/dev/null)
