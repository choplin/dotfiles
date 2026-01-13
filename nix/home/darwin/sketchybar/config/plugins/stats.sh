#!/bin/bash

source "$(dirname "$0")/colors.sh"
source "$(dirname "$0")/icons.sh"

# === CPU (ps is lighter than top) ===
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar"
mkdir -p "$CACHE_DIR"

NCPU_CACHE="$CACHE_DIR/ncpu"
if [[ -f "$NCPU_CACHE" ]]; then
    NCPU=$(cat "$NCPU_CACHE")
else
    NCPU=$(sysctl -n hw.ncpu)
    echo "$NCPU" > "$NCPU_CACHE"
fi
CPU=$(ps -A -o %cpu | awk -v ncpu="$NCPU" '{sum+=$1} END {printf "%.0f", sum/ncpu}')
CPU=${CPU:-0}

if [ "$CPU" -ge 80 ]; then
    CPU_COLOR="$COLOR_HIGH"
elif [ "$CPU" -ge 50 ]; then
    CPU_COLOR="$COLOR_MEDIUM"
else
    CPU_COLOR="$COLOR_LOW"
fi

# === Memory (single awk call) ===
MEM=$(memory_pressure 2>/dev/null | awk '/System-wide memory free percentage/ {printf "%.0f", 100-$5}')
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
CACHE_FILE="$CACHE_DIR/network"

NET_STATUS=$(ifconfig en0 2>/dev/null | awk '/status:/ {print $2}')

if [[ "$NET_STATUS" != "active" ]]; then
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

# Get current bytes (specific interface)
read -r CURRENT_DOWN CURRENT_UP <<< "$(netstat -ib -I "$INTERFACE" | awk 'NR==2 {print $7, $10}')"

# Read previous values (single read)
if [ -f "$CACHE_FILE" ]; then
    read -r PREV_DOWN PREV_UP PREV_TIME < "$CACHE_FILE"
else
    PREV_DOWN=0
    PREV_UP=0
    PREV_TIME=$(date +%s)
fi

# Save current values
CURRENT_TIME=$(date +%s)
echo "$CURRENT_DOWN $CURRENT_UP $CURRENT_TIME" > "$CACHE_FILE"

# Calculate speed
TIME_DIFF=$((CURRENT_TIME - PREV_TIME))
[ "$TIME_DIFF" -le 0 ] && TIME_DIFF=1

DOWN_DIFF=$((CURRENT_DOWN - PREV_DOWN))
UP_DIFF=$((CURRENT_UP - PREV_UP))

[ "$DOWN_DIFF" -lt 0 ] && DOWN_DIFF=0
[ "$UP_DIFF" -lt 0 ] && UP_DIFF=0

DOWN_SPEED=$((DOWN_DIFF / TIME_DIFF))
UP_SPEED=$((UP_DIFF / TIME_DIFF))

# Format speed (bash arithmetic only, no bc)
format_speed() {
    local speed=$1
    if [ "$speed" -ge 1073741824 ]; then
        printf "%d.%dG" $((speed / 1073741824)) $(((speed % 1073741824) * 10 / 1073741824))
    elif [ "$speed" -ge 1048576 ]; then
        printf "%d.%dM" $((speed / 1048576)) $(((speed % 1048576) * 10 / 1048576))
    elif [ "$speed" -ge 1024 ]; then
        printf "%dK" $((speed / 1024))
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
        click_script="$CONFIG_DIR/plugins/stats_click.sh" \
    --set network_up \
        drawing=on \
        icon="$ICON_NETWORK_UP" \
        icon.color="$PINK" \
        label="$UP_LABEL" \
        click_script="$CONFIG_DIR/plugins/stats_click.sh"
