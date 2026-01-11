#!/bin/bash

source "$(dirname "$0")/icons.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -c "AC Power")

if [ "$CHARGING" -gt 0 ]; then
    ICON="$ICON_BATTERY_CHARGING"
else
    ICON="$ICON_BATTERY_FULL"
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
