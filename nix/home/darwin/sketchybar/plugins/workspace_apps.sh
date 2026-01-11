#!/bin/bash

source "$(dirname "$0")/colors.sh"

AEROSPACE="$HOME/.nix-profile/bin/aerospace"

# Get apps in workspace (unique, max 4)
APPS=$($AEROSPACE list-windows --workspace focused --format "%{app-name}" 2>/dev/null | sort -u | head -4)

# Get focused app
FOCUSED=$($AEROSPACE list-windows --focused --format "%{app-name}" 2>/dev/null)

# Remove existing dynamic items and bracket
sketchybar --remove '/ws_app_.*/' 2>/dev/null || true
sketchybar --remove '/ws_dot_.*/' 2>/dev/null || true
sketchybar --remove ws_apps_bracket 2>/dev/null || true

if [ -z "$APPS" ]; then
    exit 0
fi

# Collect item names for bracket
ITEM_NAMES=()

# Create items for each app
INDEX=0
PREV_APP=""
while IFS= read -r APP; do
    [ -z "$APP" ] && continue

    # Add separator before (except first)
    if [ $INDEX -gt 0 ]; then
        DOT_NAME="ws_dot_${PREV_APP}_${APP}"
        # Sanitize name (remove spaces and special chars)
        DOT_NAME=$(echo "$DOT_NAME" | tr ' ' '_' | tr -cd '[:alnum:]_')

        sketchybar --add item "$DOT_NAME" left \
            --set "$DOT_NAME" \
                icon="·" \
                icon.color="$COLOR_TEXT_DIM" \
                icon.font="SF Pro:Regular:12.0" \
                icon.padding_left=2 \
                icon.padding_right=2 \
                label.drawing=off \
                background.drawing=off
        ITEM_NAMES+=("$DOT_NAME")
    fi

    # Determine color based on focus
    if [ "$APP" = "$FOCUSED" ]; then
        COLOR="$COLOR_TEXT"
    else
        COLOR="$COLOR_TEXT_DIM"
    fi

    # Sanitize app name for item name
    APP_ITEM_NAME="ws_app_$(echo "$APP" | tr ' ' '_' | tr -cd '[:alnum:]_')"

    # First item needs extra left padding to avoid overlap with workspace background
    if [ $INDEX -eq 0 ]; then
        LABEL_PAD_LEFT=28
        LABEL_PAD_RIGHT=12
    else
        LABEL_PAD_LEFT=6
        LABEL_PAD_RIGHT=6
    fi

    # Add app item
    sketchybar --add item "$APP_ITEM_NAME" left \
        --set "$APP_ITEM_NAME" \
            icon.drawing=off \
            label="$APP" \
            label.color="$COLOR" \
            label.font="SF Pro:Medium:13.0" \
            label.padding_left="$LABEL_PAD_LEFT" \
            label.padding_right="$LABEL_PAD_RIGHT" \
            background.drawing=off

    ITEM_NAMES+=("$APP_ITEM_NAME")
    PREV_APP="$APP"
    INDEX=$((INDEX + 1))
done <<< "$APPS"

# Create bracket for all items with background
if [ ${#ITEM_NAMES[@]} -gt 0 ]; then
    sketchybar --add bracket ws_apps_bracket "${ITEM_NAMES[@]}" \
        --set ws_apps_bracket \
            background.drawing=on \
            background.color="$COLOR_BAR" \
            background.corner_radius=14 \
            background.height=28
fi
