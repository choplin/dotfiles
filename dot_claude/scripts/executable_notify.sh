#!/bin/bash

# Desktop notification script
# Sends a desktop notification using osascript (AppleScript)
#
# Usage: ./notify.sh [message] [title]
# Examples:
#   ./notify.sh "Task completed!"
#   ./notify.sh "Build finished" "Claude Code"
#   ./notify.sh "Error occurred" "Warning" 

MESSAGE="${1:-Task completed!}"
TITLE="${2:-Claude Code}"

osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""