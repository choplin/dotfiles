#!/bin/bash

ACTION="$1"
DAILY="$HOME/Obsidian/My Vault/10_Daily Notes/$(date +%Y-%m-%d).md"
TOMORROW="$HOME/Obsidian/My Vault/10_Daily Notes/$(date -v+1d +%Y-%m-%d).md"
INDEX_FILE="$HOME/.local/share/sketchybar/task_index"

# Close popup
sketchybar --set task popup.drawing=off

# Get current task
INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo "-1")
if [[ $INDEX -eq -1 ]]; then
    exit 0
fi

# Get task line (with checkbox)
TASK_LINE=$(treemd -s "Tasks" "$DAILY" 2>/dev/null | grep '^- \[ \]' | sed -n "$((INDEX + 1))p")
TASK_NAME=$(echo "$TASK_LINE" | sed 's/^- \[ \] //')

[[ -z "$TASK_NAME" ]] && exit 0

case "$ACTION" in
    complete)
        # Mark as done: - [ ] -> - [x] with completion date
        COMPLETED="- [x] $TASK_NAME ✅ $(date +%Y-%m-%d)"
        perl -i -pe "s/^\Q$TASK_LINE\E\$/$COMPLETED/" "$DAILY"
        # Clear selection after completing
        echo "-1" > "$INDEX_FILE"
        ;;
    cancel)
        # Mark as cancelled: - [ ] -> - [-]
        CANCELLED="- [-] $TASK_NAME"
        perl -i -pe "s/^\Q$TASK_LINE\E\$/$CANCELLED/" "$DAILY"
        echo "-1" > "$INDEX_FILE"
        ;;
    forward)
        # Forward to tomorrow: mark as [>] in today, add to tomorrow's Tasks section
        if [[ ! -f "$TOMORROW" ]]; then
            osascript -e "display notification \"Tomorrow's daily note doesn't exist\" with title \"Task\""
            exit 0
        fi
        # Mark as forwarded in today
        FORWARDED="- [>] $TASK_NAME"
        perl -i -pe "s/^\Q$TASK_LINE\E\$/$FORWARDED/" "$DAILY"
        # Add to tomorrow's Tasks section
        perl -i -pe "s/^(## Tasks)\$/\$1\n- [ ] $TASK_NAME/" "$TOMORROW"
        echo "-1" > "$INDEX_FILE"
        ;;
    open)
        open "obsidian://open?vault=My%20Vault&file=10_Daily%20Notes%2F$(date +%Y-%m-%d)"
        exit 0
        ;;
    add)
        TASK_NAME=$(osascript -e 'text returned of (display dialog "New task:" default answer "" buttons {"Cancel", "Add"} default button "Add")' 2>/dev/null)
        [[ -z "$TASK_NAME" ]] && exit 0
        if [[ -f "$DAILY" ]]; then
            # Get current tasks once
            TASKS=$(treemd -s "Tasks" "$DAILY" 2>/dev/null | grep '^- \[')
            LAST_TASK=$(echo "$TASKS" | tail -1)
            # Add task at the end of Tasks section
            if [[ -n "$LAST_TASK" ]]; then
                perl -i -pe "s/^\Q$LAST_TASK\E\$/$LAST_TASK\n- [ ] $TASK_NAME/" "$DAILY"
            else
                perl -i -pe "s/^(## Tasks)\$/\$1\n- [ ] $TASK_NAME/" "$DAILY"
            fi
            # Select the newly added task (current uncompleted count = new task's index)
            TASK_COUNT=$(echo "$TASKS" | grep -c '^- \[ \]')
            echo "$TASK_COUNT" > "$INDEX_FILE"
        fi
        "$(dirname "$0")/task_update.sh"
        exit 0
        ;;
esac

# Trigger update
"$(dirname "$0")/task_update.sh"
