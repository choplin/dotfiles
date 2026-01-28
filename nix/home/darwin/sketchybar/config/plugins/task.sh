#!/bin/bash

DAILY="$HOME/Obsidian/My Vault/Daily Notes/$(date +%Y-%m-%d).md"
INDEX_FILE="$HOME/.local/share/sketchybar/task_index"
PLUGIN_DIR="$(dirname "$0")"

mkdir -p "$(dirname "$INDEX_FILE")"

# Get uncompleted tasks from ## Tasks section using treemd
get_tasks() {
    if [[ ! -f "$DAILY" ]]; then
        return
    fi
    treemd -s "Tasks" "$DAILY" 2>/dev/null | grep '^- \[ \]' | sed 's/^- \[ \] //'
}

# Hide all popup items
hide_all_popup_items() {
    local BATCH_ARGS=()
    # Hide task list items
    for i in {0..9}; do
        BATCH_ARGS+=(--set "task_list_$i" drawing=off)
    done
    # Hide action menu items
    BATCH_ARGS+=(--set task_menu_complete drawing=off)
    BATCH_ARGS+=(--set task_menu_cancel drawing=off)
    BATCH_ARGS+=(--set task_menu_forward drawing=off)
    BATCH_ARGS+=(--set task_menu_open drawing=off)
    BATCH_ARGS+=(--set task_menu_add drawing=off)
    sketchybar "${BATCH_ARGS[@]}"
}

case "$BUTTON" in
    right)
        # Right-click: Show action menu
        hide_all_popup_items
        INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo "-1")
        if [[ $INDEX -eq -1 ]]; then
            # No focus: show only Open Obsidian and Add Task
            sketchybar --set task_menu_open drawing=on \
                       --set task_menu_add drawing=on
        else
            # Task selected: show all options
            sketchybar --set task_menu_complete drawing=on \
                       --set task_menu_cancel drawing=on \
                       --set task_menu_forward drawing=on \
                       --set task_menu_open drawing=on \
                       --set task_menu_add drawing=on
        fi
        sketchybar --set task popup.drawing=toggle
        exit 0
        ;;
esac

case "$MODIFIER" in
    shift)
        # Shift+click: Clear selection
        echo "-1" > "$INDEX_FILE"
        "$PLUGIN_DIR/task_update.sh"
        sketchybar --update
        exit 0
        ;;
esac

# Left click: Show task list popup
hide_all_popup_items

# Get all tasks
TASKS=()
while IFS= read -r line; do
    [[ -n "$line" ]] && TASKS+=("$line")
done < <(get_tasks)
TASK_COUNT=${#TASKS[@]}

# Get current index
INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo "-1")

if [[ $TASK_COUNT -eq 0 ]]; then
    # No tasks: show only Open Obsidian and Add Task
    sketchybar --set task_menu_open drawing=on \
               --set task_menu_add drawing=on
    sketchybar --set task popup.drawing=toggle
    exit 0
fi

# Populate task list items
BATCH_ARGS=()
for i in "${!TASKS[@]}"; do
    if [[ $i -ge 10 ]]; then
        break
    fi
    TASK="${TASKS[$i]}"
    # Truncate if too long (max 35 chars) - UTF-8 safe using Perl
    TASK=$(printf "%s" "$TASK" | perl -CSD -pe 'BEGIN{use utf8;} chomp; $_ = substr($_, 0, 32) . "..." if length($_) > 35')

    BATCH_ARGS+=(--set "task_list_$i" drawing=on icon.drawing=off label="$TASK")
done
sketchybar "${BATCH_ARGS[@]}"

sketchybar --set task popup.drawing=toggle
