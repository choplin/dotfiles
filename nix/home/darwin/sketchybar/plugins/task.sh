#!/bin/bash

TASK_FILE="$HOME/.local/share/sketchybar/task.txt"
mkdir -p "$(dirname "$TASK_FILE")"
CURRENT=$(cat "$TASK_FILE" 2>/dev/null || echo "")
NEW=$(osascript -e 'text returned of (display dialog "Task:" default answer "'"$CURRENT"'")')
if [ -n "$NEW" ]; then
  echo "$NEW" > "$TASK_FILE"
  sketchybar --set task label="$NEW"
fi
