#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Now (yyyy-mm-dd HH:MM:SS)
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🕘

# Documentation:
# @raycast.description Show current time in the format of yyyy-mm-dd HH:MM:SS
# @raycast.author choplin
# @raycast.authorURL https://raycast.com/choplin

now=$(date "+%Y-%m-%d %H:%M:%S")

osascript <<EOF
tell application "System Events"
  keystroke "$now"
end tell
EOF
