#!/bin/bash

source "$(dirname "$0")/colors.sh"

MEM=$(memory_pressure 2>/dev/null | grep "System-wide memory free percentage" | awk '{print 100-$5}' | cut -d. -f1)
MEM=${MEM:-0}

if [ "$MEM" -ge 80 ]; then
    COLOR="$COLOR_HIGH"
elif [ "$MEM" -ge 50 ]; then
    COLOR="$COLOR_MEDIUM"
else
    COLOR="$COLOR_LOW"
fi

sketchybar --set "$NAME" label="${MEM}%" icon.color="$COLOR"
