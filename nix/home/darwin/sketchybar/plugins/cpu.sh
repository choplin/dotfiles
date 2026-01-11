#!/bin/bash

source "$(dirname "$0")/colors.sh"

CPU=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%' | cut -d. -f1)
CPU=${CPU:-0}

if [ "$CPU" -ge 80 ]; then
    COLOR="$COLOR_HIGH"
elif [ "$CPU" -ge 50 ]; then
    COLOR="$COLOR_MEDIUM"
else
    COLOR="$COLOR_LOW"
fi

sketchybar --set "$NAME" label="${CPU}%" icon.color="$COLOR"
