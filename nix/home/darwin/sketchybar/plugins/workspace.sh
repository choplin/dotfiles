#!/bin/bash

source "$(dirname "$0")/colors.sh"

AEROSPACE="$HOME/.nix-profile/bin/aerospace"

# Get all data in parallel
WS_FILE=$(mktemp)
APPS_FILE=$(mktemp)
FOCUSED_FILE=$(mktemp)
trap 'rm -f "$WS_FILE" "$APPS_FILE" "$FOCUSED_FILE"' EXIT

PLUGIN_DIR="$(dirname "$0")"

$AEROSPACE list-workspaces --focused 2>/dev/null > "$WS_FILE" &
$AEROSPACE list-windows --workspace focused --format "%{window-id}|%{app-name}" 2>/dev/null > "$APPS_FILE" &
$AEROSPACE list-windows --focused --format "%{app-name}" 2>/dev/null > "$FOCUSED_FILE" &
wait

WORKSPACE=$(cat "$WS_FILE")
FOCUSED=$(cat "$FOCUSED_FILE")

[ -z "$WORKSPACE" ] && WORKSPACE="?"

# Read apps into arrays (deduplicated by app-name, keeping first window-id)
# Use awk for deduplication (bash 3.2 compatible - no associative arrays)
APP_NAMES=()
APP_WINDOW_IDS=()
while IFS='|' read -r WINDOW_ID APP_NAME; do
    [ -n "$APP_NAME" ] && APP_NAMES+=("$APP_NAME") && APP_WINDOW_IDS+=("$WINDOW_ID")
done < <(awk -F'|' '!seen[$2]++ {print}' "$APPS_FILE" | head -4)

# Build batch command
BATCH_ARGS=(--set "$NAME" label="$WORKSPACE")

# Update fixed app items (0-3)
for i in 0 1 2 3; do
    if [ $i -lt ${#APP_NAMES[@]} ]; then
        APP="${APP_NAMES[$i]}"
        WINDOW_ID="${APP_WINDOW_IDS[$i]}"

        # Determine color based on focus
        if [ "$APP" = "$FOCUSED" ]; then
            COLOR="$COLOR_TEXT"
        else
            COLOR="$COLOR_TEXT_DIM"
        fi

        # First item needs extra left padding
        if [ $i -eq 0 ]; then
            LABEL_PAD_LEFT=28
            LABEL_PAD_RIGHT=12
        else
            LABEL_PAD_LEFT=6
            LABEL_PAD_RIGHT=6
        fi

        BATCH_ARGS+=(--set "ws_app_$i"
            drawing=on
            label="$APP"
            label.color="$COLOR"
            label.font="SF Pro:Medium:13.0"
            label.padding_left="$LABEL_PAD_LEFT"
            label.padding_right="$LABEL_PAD_RIGHT"
            click_script="$PLUGIN_DIR/app_click.sh $WINDOW_ID")

        # Show dot separator before this item (except first)
        if [ $i -gt 0 ]; then
            DOT_IDX=$((i - 1))
            BATCH_ARGS+=(--set "ws_dot_$DOT_IDX"
                drawing=on
                icon="·"
                icon.color="$COLOR_TEXT_DIM"
                icon.font="SF Pro:Regular:12.0"
                icon.padding_left=2
                icon.padding_right=2)
        fi
    else
        # Hide unused app item
        BATCH_ARGS+=(--set "ws_app_$i" drawing=off)

        # Hide dot before this item
        if [ $i -gt 0 ]; then
            DOT_IDX=$((i - 1))
            BATCH_ARGS+=(--set "ws_dot_$DOT_IDX" drawing=off)
        fi
    fi
done

# Execute single batch command
sketchybar "${BATCH_ARGS[@]}"
