#!/bin/bash

# Select a task by index from the task list popup

INDEX="$1"
INDEX_FILE="$HOME/.local/share/sketchybar/task_index"

mkdir -p "$(dirname "$INDEX_FILE")"

# Close popup
sketchybar --set task popup.drawing=off

# Set the selected index
echo "$INDEX" > "$INDEX_FILE"

# Trigger update
"$(dirname "$0")/task_update.sh"
sketchybar --update
