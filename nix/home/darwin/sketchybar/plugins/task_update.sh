#!/bin/bash

source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/icons.sh"

# Handle mouse.exited.global: close popup
case "$SENDER" in
    mouse.exited.global)
        sketchybar --set task popup.drawing=off
        exit 0
        ;;
esac

DAILY="$HOME/Obsidian/My Vault/Diary/Daily/$(date +%Y-%m-%d).md"
INDEX_FILE="$HOME/.local/share/sketchybar/task_index"

# Get uncompleted tasks from ## Tasks section using treemd
get_tasks() {
    if [[ ! -f "$DAILY" ]]; then
        return
    fi
    treemd -s "Tasks" "$DAILY" 2>/dev/null | grep '^- \[ \]' | sed 's/^- \[ \] //'
}

# Read current index (-1 = no selection)
mkdir -p "$(dirname "$INDEX_FILE")"
INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo "-1")

# No selection state
if [[ $INDEX -eq -1 ]]; then
    sketchybar --set task icon="$ICON_WORKSPACE" label="No focus" label.color="$COLOR_TEXT_DIM"
    exit 0
fi

# Get all tasks into array
TASKS=()
while IFS= read -r line; do
    [[ -n "$line" ]] && TASKS+=("$line")
done < <(get_tasks)
TASK_COUNT=${#TASKS[@]}

if [[ $TASK_COUNT -eq 0 ]]; then
    echo "-1" > "$INDEX_FILE"
    sketchybar --set task icon="$ICON_WORKSPACE" label="No focus" label.color="$COLOR_TEXT_DIM"
    exit 0
fi

# Ensure index is within bounds
if [[ $INDEX -ge $TASK_COUNT ]]; then
    INDEX=0
    echo "$INDEX" > "$INDEX_FILE"
fi

CURRENT_TASK="${TASKS[$INDEX]}"

# Truncate if too long (max 30 chars)
if [[ ${#CURRENT_TASK} -gt 30 ]]; then
    CURRENT_TASK="${CURRENT_TASK:0:27}..."
fi

sketchybar --set task icon="$ICON_WORKSPACE" label="$CURRENT_TASK" label.color="$COLOR_TEXT"
