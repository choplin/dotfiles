#!/bin/bash

# Focus the window when its app name is clicked in sketchybar
# Usage: app_click.sh <window-id>

WINDOW_ID="$1"
[ -z "$WINDOW_ID" ] && exit 0

"$HOME/.nix-profile/bin/aerospace" focus --window-id "$WINDOW_ID"
