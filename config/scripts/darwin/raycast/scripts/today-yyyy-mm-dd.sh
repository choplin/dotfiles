#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Today (yyyy-mm-dd)
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📅

# Documentation:
# @raycast.description Show current date in the format of yyyy-mm-dd
# @raycast.author choplin
# @raycast.authorURL https://raycast.com/choplin

today=$(date "+%Y-%m-%d")

osascript <<EOF
tell application "System Events"
  keystroke "$today"
end tell
EOF
