#!/bin/bash

source "$(dirname "$0")/colors.sh"

AEROSPACE="$HOME/.nix-profile/bin/aerospace"

# Get all data in parallel
WS_FILE=$(mktemp)
APPS_FILE=$(mktemp)
FOCUSED_FILE=$(mktemp)
trap 'rm -f "$WS_FILE" "$APPS_FILE" "$FOCUSED_FILE"' EXIT

$AEROSPACE list-workspaces --focused 2>/dev/null > "$WS_FILE" &
$AEROSPACE list-windows --workspace focused --format "%{app-name}" 2>/dev/null | sort -u | head -4 > "$APPS_FILE" &
$AEROSPACE list-windows --focused --format "%{app-name}" 2>/dev/null > "$FOCUSED_FILE" &
wait

WORKSPACE=$(cat "$WS_FILE")
APPS=$(cat "$APPS_FILE")
FOCUSED=$(cat "$FOCUSED_FILE")

[ -z "$WORKSPACE" ] && WORKSPACE="?"

# Build single batch command
BATCH_ARGS=(
    --remove '/ws_app_.*/'
    --remove '/ws_dot_.*/'
    --remove ws_apps_bracket
    --set "$NAME" label="$WORKSPACE"
)

if [ -n "$APPS" ]; then
    ITEM_NAMES=()
    INDEX=0
    PREV_APP=""

    while IFS= read -r APP; do
        [ -z "$APP" ] && continue

        # Add separator before (except first)
        if [ $INDEX -gt 0 ]; then
            DOT_NAME="ws_dot_${PREV_APP}_${APP}"
            DOT_NAME=$(echo "$DOT_NAME" | tr ' ' '_' | tr -cd '[:alnum:]_')

            BATCH_ARGS+=(--add item "$DOT_NAME" left)
            BATCH_ARGS+=(--set "$DOT_NAME"
                icon="·"
                icon.color="$COLOR_TEXT_DIM"
                icon.font="SF Pro:Regular:12.0"
                icon.padding_left=2
                icon.padding_right=2
                label.drawing=off
                background.drawing=off)
            ITEM_NAMES+=("$DOT_NAME")
        fi

        # Determine color based on focus
        if [ "$APP" = "$FOCUSED" ]; then
            COLOR="$COLOR_TEXT"
        else
            COLOR="$COLOR_TEXT_DIM"
        fi

        APP_ITEM_NAME="ws_app_$(echo "$APP" | tr ' ' '_' | tr -cd '[:alnum:]_')"

        if [ $INDEX -eq 0 ]; then
            LABEL_PAD_LEFT=28
            LABEL_PAD_RIGHT=12
        else
            LABEL_PAD_LEFT=6
            LABEL_PAD_RIGHT=6
        fi

        BATCH_ARGS+=(--add item "$APP_ITEM_NAME" left)
        BATCH_ARGS+=(--set "$APP_ITEM_NAME"
            icon.drawing=off
            label="$APP"
            label.color="$COLOR"
            label.font="SF Pro:Medium:13.0"
            label.padding_left="$LABEL_PAD_LEFT"
            label.padding_right="$LABEL_PAD_RIGHT"
            background.drawing=off)

        ITEM_NAMES+=("$APP_ITEM_NAME")
        PREV_APP="$APP"
        INDEX=$((INDEX + 1))
    done <<< "$APPS"

    # Add bracket
    if [ ${#ITEM_NAMES[@]} -gt 0 ]; then
        BATCH_ARGS+=(--add bracket ws_apps_bracket "${ITEM_NAMES[@]}")
        BATCH_ARGS+=(--set ws_apps_bracket
            background.drawing=on
            background.color="$COLOR_BAR"
            background.corner_radius=14
            background.height=28)
    fi
fi

# Execute single batch command
sketchybar "${BATCH_ARGS[@]}" 2>/dev/null || true
