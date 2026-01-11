#!/bin/bash

TASK_FILE="$HOME/.local/share/sketchybar/task.txt"
if [ -f "$TASK_FILE" ]; then
  TASK=$(cat "$TASK_FILE")
  if [ -n "$TASK" ]; then
    sketchybar --set "$NAME" label="$TASK"
  else
    sketchybar --set "$NAME" label="No task"
  fi
else
  sketchybar --set "$NAME" label="No task"
fi
