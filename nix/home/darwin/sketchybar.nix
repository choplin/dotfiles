{pkgs, ...}: let
  # Color definitions (Glass style)
  colors = {
    bar = "0x40000000"; # Black, 25% opacity
    text = "0xffffffff"; # White
    textDim = "0x99ffffff"; # Dim white
    accent = "0xff61afef"; # Blue accent
    # Load-based colors
    low = "0xffffffff"; # White (0-50%)
    medium = "0xffe5c07b"; # Yellow (50-80%)
    high = "0xffe06c75"; # Red (80%+)
  };

  # SF Symbols icons
  icons = {
    cpu = "􀧓";
    memory = "􀫦";
    batteryFull = "􀛨";
    batteryCharging = "􀢋";
    clock = "􀐫";
    music = "􀑪";
    pomodoro = "􀐱";
    workspace = "􀏟";
    play = "􀊄";
    pause = "􀊆";
  };

  # Plugin: Current workspace + app names
  workspacePlugin = pkgs.writeShellScript "workspace.sh" ''
    AEROSPACE="/Users/aki/.nix-profile/bin/aerospace"

    # Get current focused workspace
    WORKSPACE=$($AEROSPACE list-workspaces --focused 2>/dev/null)
    if [ -z "$WORKSPACE" ]; then
      WORKSPACE="?"
    fi

    # Get apps in current workspace (show first 3)
    APPS=$($AEROSPACE list-windows --workspace focused --format "%{app-name}" 2>/dev/null | sort -u | head -3 | tr '\n' ' ' | xargs)

    if [ -n "$APPS" ]; then
      sketchybar --set workspace icon="$WORKSPACE" label="$APPS"
    else
      sketchybar --set workspace icon="$WORKSPACE" label=""
    fi
  '';

  # Plugin: CPU with load-based color
  cpuPlugin = pkgs.writeShellScript "cpu.sh" ''
    CPU=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | tr -d '%' | cut -d. -f1)
    CPU=''${CPU:-0}

    if [ "$CPU" -ge 80 ]; then
      COLOR="${colors.high}"
    elif [ "$CPU" -ge 50 ]; then
      COLOR="${colors.medium}"
    else
      COLOR="${colors.low}"
    fi

    sketchybar --set "$NAME" label="''${CPU}%" icon.color="$COLOR"
  '';

  # Plugin: Memory with load-based color
  memoryPlugin = pkgs.writeShellScript "memory.sh" ''
    MEM=$(memory_pressure 2>/dev/null | grep "System-wide memory free percentage" | awk '{print 100-$5}' | cut -d. -f1)
    MEM=''${MEM:-0}

    if [ "$MEM" -ge 80 ]; then
      COLOR="${colors.high}"
    elif [ "$MEM" -ge 50 ]; then
      COLOR="${colors.medium}"
    else
      COLOR="${colors.low}"
    fi

    sketchybar --set "$NAME" label="''${MEM}%" icon.color="$COLOR"
  '';

  # Plugin: Battery
  batteryPlugin = pkgs.writeShellScript "battery.sh" ''
    PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | head -1 | tr -d '%')
    CHARGING=$(pmset -g batt | grep -c "AC Power")

    if [ "$CHARGING" -gt 0 ]; then
      ICON="${icons.batteryCharging}"
    else
      ICON="${icons.batteryFull}"
    fi

    sketchybar --set "$NAME" icon="$ICON" label="''${PERCENTAGE}%"
  '';

  # Plugin: Clock
  clockPlugin = pkgs.writeShellScript "clock.sh" ''
    sketchybar --set "$NAME" label="$(date '+%a %b %d %H:%M')"
  '';

  # Plugin: YouTube Music (via Now Playing)
  mediaPlugin = pkgs.writeShellScript "media.sh" ''
    STATE=$(echo "$INFO" | jq -r '.state // empty')
    APP=$(echo "$INFO" | jq -r '.app // empty')

    if [ "$STATE" = "playing" ]; then
      ARTIST=$(echo "$INFO" | jq -r '.artist // empty')
      TITLE=$(echo "$INFO" | jq -r '.title // empty')

      # Truncate if too long
      if [ ''${#TITLE} -gt 30 ]; then
        TITLE="''${TITLE:0:27}..."
      fi

      if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        sketchybar --set "$NAME" label="$ARTIST - $TITLE" icon="${icons.play}" drawing=on
      else
        sketchybar --set "$NAME" drawing=off
      fi
    else
      sketchybar --set "$NAME" drawing=off
    fi
  '';

  # Plugin: Task input
  taskPlugin = pkgs.writeShellScript "task.sh" ''
    TASK_FILE="$HOME/.local/share/sketchybar/task.txt"
    mkdir -p "$(dirname "$TASK_FILE")"
    CURRENT=$(cat "$TASK_FILE" 2>/dev/null || echo "")
    NEW=$(osascript -e 'text returned of (display dialog "Task:" default answer "'"$CURRENT"'")')
    if [ -n "$NEW" ]; then
      echo "$NEW" > "$TASK_FILE"
      sketchybar --set task label="$NEW"
    fi
  '';

  # Plugin: Task update
  taskUpdatePlugin = pkgs.writeShellScript "task_update.sh" ''
    TASK_FILE="$HOME/.local/share/sketchybar/task.txt"
    if [ -f "$TASK_FILE" ]; then
      TASK=$(cat "$TASK_FILE")
      if [ -n "$TASK" ]; then
        sketchybar --set "$NAME" label="$TASK"
      else
        sketchybar --set "$NAME" label="No task"
      fi
    else
      sketchybar --set "$NAME" label="No task"
    fi
  '';

  # Plugin: Pomodoro
  pomodoroClickPlugin = pkgs.writeShellScript "pomodoro_click.sh" ''
    POMO_DIR="$HOME/.local/share/sketchybar"
    POMO_FILE="$POMO_DIR/pomodoro"
    mkdir -p "$POMO_DIR"

    STATE=$(cat "$POMO_FILE" 2>/dev/null | head -1 || echo "idle")

    case "$STATE" in
      idle)
        # Start work session (25 min)
        END_TIME=$(($(date +%s) + 25 * 60))
        echo "work" > "$POMO_FILE"
        echo "$END_TIME" >> "$POMO_FILE"
        ;;
      work|break)
        # Stop/reset
        echo "idle" > "$POMO_FILE"
        ;;
    esac

    # Trigger update
    sketchybar --trigger pomodoro_update
  '';

  pomodoroUpdatePlugin = pkgs.writeShellScript "pomodoro_update.sh" ''
    POMO_FILE="$HOME/.local/share/sketchybar/pomodoro"

    if [ ! -f "$POMO_FILE" ]; then
      sketchybar --set "$NAME" icon="${icons.pomodoro}" label="--:--" icon.color="${colors.textDim}"
      exit 0
    fi

    STATE=$(head -1 "$POMO_FILE" 2>/dev/null || echo "idle")
    END_TIME=$(tail -1 "$POMO_FILE" 2>/dev/null || echo "0")
    NOW=$(date +%s)

    case "$STATE" in
      work)
        REMAINING=$((END_TIME - NOW))
        if [ "$REMAINING" -le 0 ]; then
          # Work done, start break (5 min)
          END_TIME=$((NOW + 5 * 60))
          echo "break" > "$POMO_FILE"
          echo "$END_TIME" >> "$POMO_FILE"
          osascript -e 'display notification "Time for a break!" with title "Pomodoro"' 2>/dev/null || true
          REMAINING=$((5 * 60))
          COLOR="${colors.accent}"
        else
          COLOR="${colors.high}"
        fi
        MINS=$((REMAINING / 60))
        SECS=$((REMAINING % 60))
        sketchybar --set "$NAME" icon="${icons.pomodoro}" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="$COLOR"
        ;;
      break)
        REMAINING=$((END_TIME - NOW))
        if [ "$REMAINING" -le 0 ]; then
          # Break done
          echo "idle" > "$POMO_FILE"
          osascript -e 'display notification "Break over! Ready to work?" with title "Pomodoro"' 2>/dev/null || true
          sketchybar --set "$NAME" icon="${icons.pomodoro}" label="--:--" icon.color="${colors.textDim}"
        else
          MINS=$((REMAINING / 60))
          SECS=$((REMAINING % 60))
          sketchybar --set "$NAME" icon="${icons.pomodoro}" label="$(printf '%02d:%02d' $MINS $SECS)" icon.color="${colors.accent}"
        fi
        ;;
      *)
        sketchybar --set "$NAME" icon="${icons.pomodoro}" label="--:--" icon.color="${colors.textDim}"
        ;;
    esac
  '';
in {
  programs.sketchybar = {
    enable = pkgs.stdenv.isDarwin;
    extraPackages = with pkgs; [jq];
    config = ''
      #!/bin/bash

      # Bar settings (glass style - background on entire bar)
      sketchybar --bar \
        height=32 \
        color=${colors.bar} \
        blur_radius=30 \
        corner_radius=10 \
        position=top \
        sticky=on \
        margin=8 \
        padding_left=12 \
        padding_right=12 \
        y_offset=2

      # Default item settings (no background on items)
      sketchybar --default \
        background.drawing=off \
        icon.font="SF Pro:Semibold:14.0" \
        icon.color=${colors.text} \
        icon.padding_left=8 \
        icon.padding_right=4 \
        label.font="SF Pro:Medium:13.0" \
        label.color=${colors.text} \
        label.padding_left=4 \
        label.padding_right=8 \
        padding_left=0 \
        padding_right=0

      # === Events ===
      sketchybar --add event aerospace_workspace_change
      sketchybar --add event pomodoro_update

      # === Left section ===
      # Current workspace + app names
      sketchybar --add item workspace left \
        --subscribe workspace aerospace_workspace_change \
        --set workspace \
          label.font="SF Pro:Bold:14.0" \
          script="${workspacePlugin}"

      # === Center section ===
      # Current task
      sketchybar --add item task center \
        --set task \
          icon="${icons.workspace}" \
          label="No task" \
          update_freq=60 \
          click_script="${taskPlugin}" \
          script="${taskUpdatePlugin}"

      # Pomodoro timer
      sketchybar --add item pomodoro center \
        --subscribe pomodoro pomodoro_update \
        --set pomodoro \
          icon="${icons.pomodoro}" \
          icon.color=${colors.textDim} \
          label="--:--" \
          update_freq=1 \
          click_script="${pomodoroClickPlugin}" \
          script="${pomodoroUpdatePlugin}"

      # === Right section ===
      # Clock (rightmost)
      sketchybar --add item clock right \
        --set clock \
          icon="${icons.clock}" \
          update_freq=10 \
          script="${clockPlugin}"

      # Battery
      sketchybar --add item battery right \
        --subscribe battery power_source_change system_woke \
        --set battery \
          icon="${icons.batteryFull}" \
          update_freq=60 \
          script="${batteryPlugin}"

      # Memory
      sketchybar --add item memory right \
        --set memory \
          icon="${icons.memory}" \
          update_freq=10 \
          script="${memoryPlugin}"

      # CPU
      sketchybar --add item cpu right \
        --set cpu \
          icon="${icons.cpu}" \
          update_freq=5 \
          script="${cpuPlugin}"

      # YouTube Music / Now Playing
      sketchybar --add item media right \
        --subscribe media media_change \
        --set media \
          icon="${icons.music}" \
          drawing=off \
          script="${mediaPlugin}"

      sketchybar --update
    '';
  };
}
