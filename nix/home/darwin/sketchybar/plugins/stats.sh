#!/bin/bash

source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/icons.sh"

# === CPU ===
CPU=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%' | cut -d. -f1)
CPU=${CPU:-0}

if [ "$CPU" -ge 80 ]; then
    CPU_COLOR="$COLOR_HIGH"
elif [ "$CPU" -ge 50 ]; then
    CPU_COLOR="$COLOR_MEDIUM"
else
    CPU_COLOR="$COLOR_LOW"
fi

# === Memory ===
MEM=$(memory_pressure 2>/dev/null | grep "System-wide memory free percentage" | awk '{print 100-$5}' | cut -d. -f1)
MEM=${MEM:-0}

if [ "$MEM" -ge 80 ]; then
    MEM_COLOR="$COLOR_HIGH"
elif [ "$MEM" -ge 50 ]; then
    MEM_COLOR="$COLOR_MEDIUM"
else
    MEM_COLOR="$COLOR_LOW"
fi

# === Network ===
INTERFACE="en0"
CACHE_FILE="/tmp/sketchybar_network_cache"

NET_STATUS=$(ifconfig en0 2>/dev/null | grep -o "status: .*" | awk '{print $2}')

if [[ "$NET_STATUS" != "active" ]]; then
    # WiFi disconnected
    sketchybar \
        --set cpu label="${CPU}%" icon.color="$CPU_COLOR" \
        --set memory label="${MEM}%" icon.color="$MEM_COLOR" \
        --set network_down \
            icon="$ICON_WIFI_OFF" \
            icon.color="$COLOR_TEXT_DIM" \
            label="" \
            click_script="open 'x-apple.systempreferences:com.apple.preference.network'" \
        --set network_up drawing=off
    exit 0
fi

# Get current bytes
CURRENT=$(netstat -ib | grep -E "^${INTERFACE}\s" | head -1 | awk '{print $7, $10}')
CURRENT_DOWN=$(echo "$CURRENT" | awk '{print $1}')
CURRENT_UP=$(echo "$CURRENT" | awk '{print $2}')

# Read previous values
if [ -f "$CACHE_FILE" ]; then
    PREV=$(cat "$CACHE_FILE")
    PREV_DOWN=$(echo "$PREV" | awk '{print $1}')
    PREV_UP=$(echo "$PREV" | awk '{print $2}')
    PREV_TIME=$(echo "$PREV" | awk '{print $3}')
else
    PREV_DOWN=0
    PREV_UP=0
    PREV_TIME=$(date +%s)
fi

# Save current values
CURRENT_TIME=$(date +%s)
echo "$CURRENT_DOWN $CURRENT_UP $CURRENT_TIME" > "$CACHE_FILE"

# Calculate speed (bytes per second)
TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
if [ "$TIME_DIFF" -le 0 ]; then
    TIME_DIFF=1
fi

DOWN_DIFF=$((CURRENT_DOWN - PREV_DOWN))
UP_DIFF=$((CURRENT_UP - PREV_UP))

# Handle counter reset
if [ "$DOWN_DIFF" -lt 0 ]; then DOWN_DIFF=0; fi
if [ "$UP_DIFF" -lt 0 ]; then UP_DIFF=0; fi

DOWN_SPEED=$((DOWN_DIFF / TIME_DIFF))
UP_SPEED=$((UP_DIFF / TIME_DIFF))

# Format speed (convert to human readable)
format_speed() {
    local speed=$1
    if [ "$speed" -ge 1073741824 ]; then
        printf "%.1fG" "$(echo "scale=1; $speed/1073741824" | bc)"
    elif [ "$speed" -ge 1048576 ]; then
        printf "%.1fM" "$(echo "scale=1; $speed/1048576" | bc)"
    elif [ "$speed" -ge 1024 ]; then
        printf "%.0fK" "$(echo "scale=0; $speed/1024" | bc)"
    else
        printf "0K"
    fi
}

DOWN_LABEL=$(format_speed "$DOWN_SPEED")
UP_LABEL=$(format_speed "$UP_SPEED")

# === Update all items ===
sketchybar \
    --set cpu label="${CPU}%" icon.color="$CPU_COLOR" \
    --set memory label="${MEM}%" icon.color="$MEM_COLOR" \
    --set network_down \
        icon="$ICON_NETWORK_DOWN" \
        icon.color="$CYAN" \
        label="$DOWN_LABEL" \
        click_script="" \
    --set network_up \
        drawing=on \
        icon="$ICON_NETWORK_UP" \
        icon.color="$PINK" \
        label="$UP_LABEL"
