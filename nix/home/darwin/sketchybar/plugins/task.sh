#!/bin/bash

DAILY="$HOME/Obsidian/My Vault/Diary/Daily/$(date +%Y-%m-%d).md"
INDEX_FILE="$HOME/.local/share/sketchybar/task_index"

mkdir -p "$(dirname "$INDEX_FILE")"

case "$BUTTON" in
    right)
        INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo "-1")
        if [[ $INDEX -eq -1 ]]; then
            # No focus: show only Open Obsidian
            sketchybar --set task_menu_complete drawing=off \
                       --set task_menu_cancel drawing=off \
                       --set task_menu_forward drawing=off \
                       --set task_menu_open drawing=on
        else
            # Task selected: show all options
            sketchybar --set task_menu_complete drawing=on \
                       --set task_menu_cancel drawing=on \
                       --set task_menu_forward drawing=on \
                       --set task_menu_open drawing=on
        fi
        sketchybar --set task popup.drawing=toggle
        exit 0
        ;;
esac

case "$MODIFIER" in
    shift)
        # Shift+click: Clear selection
        echo "-1" > "$INDEX_FILE"
        "$(dirname "$0")/task_update.sh"
        sketchybar --update
        exit 0
        ;;
esac

# Left click: Rotate through tasks
INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo "-1")

# If no selection, start from 0; otherwise increment
if [[ $INDEX -eq -1 ]]; then
    INDEX=0
else
    INDEX=$((INDEX + 1))
fi
echo "$INDEX" > "$INDEX_FILE"

# Trigger update (task_update.sh will handle bounds/wrap)
"$(dirname "$0")/task_update.sh"
sketchybar --update
