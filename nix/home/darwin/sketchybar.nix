{pkgs, ...}: let
  # Color definitions
  colors = {
    bg = "0x80333333";
    leftBorder = "0xff61afef";
    centerBorder = "0xff98c379";
    rightBorder = "0xffc678dd";
    active = "0xffffffff";
    inactive = "0x80ffffff";
    transparent = "0x00000000";
  };

  # Plugin scripts
  aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set "$NAME" background.drawing=on label.color=${colors.active}
    else
      sketchybar --set "$NAME" background.drawing=off label.color=${colors.inactive}
    fi
  '';

  frontAppPlugin = pkgs.writeShellScript "front_app.sh" ''
    sketchybar --set "$NAME" label="$INFO"
  '';

  taskPlugin = pkgs.writeShellScript "task.sh" ''
    TASK_FILE="$HOME/.local/share/sketchybar/task.txt"
    mkdir -p "$(dirname "$TASK_FILE")"
    CURRENT=$(cat "$TASK_FILE" 2>/dev/null || echo "")
    NEW=$(osascript -e 'text returned of (display dialog "今やること:" default answer "'"$CURRENT"'")')
    if [ -n "$NEW" ]; then
      echo "$NEW" > "$TASK_FILE"
      sketchybar --set task label="$NEW"
    fi
  '';

  taskUpdatePlugin = pkgs.writeShellScript "task_update.sh" ''
    TASK_FILE="$HOME/.local/share/sketchybar/task.txt"
    if [ -f "$TASK_FILE" ]; then
      TASK=$(cat "$TASK_FILE")
      sketchybar --set "$NAME" label="$TASK"
    else
      sketchybar --set "$NAME" label="Click to set"
    fi
  '';

  mediaPlugin = pkgs.writeShellScript "media.sh" ''
    STATE=$(echo "$INFO" | jq -r '.state')
    if [ "$STATE" = "playing" ]; then
      ARTIST=$(echo "$INFO" | jq -r '.artist')
      TITLE=$(echo "$INFO" | jq -r '.title')
      sketchybar --set "$NAME" label="$ARTIST - $TITLE" drawing=on
    else
      sketchybar --set "$NAME" drawing=off
    fi
  '';

  cpuPlugin = pkgs.writeShellScript "cpu.sh" ''
    CPU=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
    sketchybar --set "$NAME" icon="CPU" label="''${CPU}%"
  '';

  memoryPlugin = pkgs.writeShellScript "memory.sh" ''
    MEM=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print 100-$5}')
    sketchybar --set "$NAME" icon="MEM" label="''${MEM}%"
  '';

  clockPlugin = pkgs.writeShellScript "clock.sh" ''
    sketchybar --set "$NAME" label="$(date '+%m/%d %H:%M')"
  '';

  timerPlugin = pkgs.writeShellScript "timer.sh" ''
    # macOS timer state (placeholder for future extension)
    sketchybar --set "$NAME" label=""
  '';

  batteryPlugin = pkgs.writeShellScript "battery.sh" ''
    PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | head -1)
    CHARGING=$(pmset -g batt | grep -c "AC Power")
    if [ "$CHARGING" -gt 0 ]; then
      ICON="⚡"
    else
      ICON="🔋"
    fi
    sketchybar --set "$NAME" icon="$ICON" label="$PERCENTAGE"
  '';

  # Workspace list (sync with aerospace.nix)
  workspaces = ["Mail" "Slack" "Obsidian" "Notion" "T" "Atlas" "S" "Comet" "Browser" "Browser-work" "Z" "X" "C" "Zed" "Terminal"];

  # Short label for workspace
  shortLabel = ws:
    if ws == "Browser-work"
    then "Bw"
    else if ws == "Obsidian"
    then "Obs"
    else if ws == "Terminal"
    then "Term"
    else builtins.substring 0 1 ws;
in {
  programs.sketchybar = {
    enable = pkgs.stdenv.isDarwin;
    extraPackages = with pkgs; [jq];
    config = ''
      #!/bin/bash

      # Bar settings
      sketchybar --bar \
        height=32 \
        color=${colors.transparent} \
        position=top \
        sticky=on \
        padding_left=8 \
        padding_right=8

      # Default item settings
      sketchybar --default \
        background.height=26 \
        background.corner_radius=8 \
        background.color=${colors.bg} \
        background.border_width=2 \
        padding_left=4 \
        padding_right=4 \
        icon.padding_left=6 \
        icon.padding_right=4 \
        label.padding_left=4 \
        label.padding_right=6

      # === Left section (blue border) ===
      sketchybar --add event aerospace_workspace_change

      ${builtins.concatStringsSep "\n" (map (ws: ''
          sketchybar --add item space.${ws} left \
            --subscribe space.${ws} aerospace_workspace_change \
            --set space.${ws} \
              background.border_color=${colors.leftBorder} \
              background.drawing=off \
              label="${shortLabel ws}" \
              click_script="aerospace workspace ${ws}" \
              script="${aerospacePlugin} ${ws}"
        '')
        workspaces)}

      # Front app
      sketchybar --add item front_app left \
        --subscribe front_app front_app_switched \
        --set front_app \
          background.border_color=${colors.leftBorder} \
          icon.drawing=off \
          script="${frontAppPlugin}"

      # === Center section (green border) ===
      # Current task
      sketchybar --add item task center \
        --set task \
          background.border_color=${colors.centerBorder} \
          icon="📌" \
          label="Click to set" \
          update_freq=60 \
          click_script="${taskPlugin}" \
          script="${taskUpdatePlugin}"

      # Now Playing
      sketchybar --add item media center \
        --subscribe media media_change \
        --set media \
          background.border_color=${colors.centerBorder} \
          icon="♪" \
          label="Not Playing" \
          drawing=off \
          script="${mediaPlugin}"

      # === Right section (purple border) ===
      # Battery (rightmost)
      sketchybar --add item battery right \
        --subscribe battery power_source_change system_woke \
        --set battery \
          background.border_color=${colors.rightBorder} \
          update_freq=60 \
          script="${batteryPlugin}"

      # Timer
      sketchybar --add item timer right \
        --set timer \
          background.border_color=${colors.rightBorder} \
          drawing=off \
          script="${timerPlugin}"

      # Clock
      sketchybar --add item clock right \
        --set clock \
          background.border_color=${colors.rightBorder} \
          update_freq=10 \
          script="${clockPlugin}"

      # Memory
      sketchybar --add item memory right \
        --set memory \
          background.border_color=${colors.rightBorder} \
          update_freq=10 \
          script="${memoryPlugin}"

      # CPU
      sketchybar --add item cpu right \
        --set cpu \
          background.border_color=${colors.rightBorder} \
          update_freq=5 \
          script="${cpuPlugin}"

      sketchybar --update
    '';
  };
}
