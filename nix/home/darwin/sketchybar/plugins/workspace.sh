#!/bin/bash

AEROSPACE="$HOME/.nix-profile/bin/aerospace"

# Get current focused workspace
WORKSPACE=$($AEROSPACE list-workspaces --focused 2>/dev/null)
if [ -z "$WORKSPACE" ]; then
    WORKSPACE="?"
fi

sketchybar --set "$NAME" label="$WORKSPACE"

# Trigger workspace_apps update after workspace label is set
sketchybar --trigger workspace_apps_update
