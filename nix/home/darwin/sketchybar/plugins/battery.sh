#!/bin/bash

source "$(dirname "$0")/icons.sh"
source "$(dirname "$0")/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep -c "AC Power")

# 充電中は専用アイコン
if [ "$CHARGING" -gt 0 ]; then
    ICON="$ICON_BATTERY_CHARGING"
    ICON_COLOR="$COLOR_LOW"
# 残量に応じてアイコンと色を設定（シンプル3段階）
elif [ "$PERCENTAGE" -ge 50 ]; then
    ICON="$ICON_BATTERY_100"
    ICON_COLOR="$COLOR_LOW"
elif [ "$PERCENTAGE" -ge 20 ]; then
    ICON="$ICON_BATTERY_50"
    ICON_COLOR="$COLOR_MEDIUM"
else
    ICON="$ICON_BATTERY_25"
    ICON_COLOR="$COLOR_HIGH"
fi

# 10%以下は空アイコン
if [ "$PERCENTAGE" -le 10 ] && [ "$CHARGING" -eq 0 ]; then
    ICON="$ICON_BATTERY_0"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" label="${PERCENTAGE}%"
