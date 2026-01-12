#!/usr/bin/env bash
# $NAME: clicked item name (cpu, memory, network_up, network_down)
# $BUTTON: "left" or "right"

[[ "$BUTTON" != "right" ]] && exit 0

case "$NAME" in
    cpu) WIDGET="cpu" ;;
    memory) WIDGET="mem" ;;
    network_up|network_down) WIDGET="net" ;;
esac

wezterm start -- btm --default_widget_type "$WIDGET"
