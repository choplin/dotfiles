{
  pkgs,
  lib,
  ...
}: let
  app_id_to_workspace = app_id: workspace: {
    "if".app-id = app_id;
    run = ["move-node-to-workspace ${workspace}"];
  };

  app_name_to_workspace = app_name: workspace: {
    "if".app-name-regex-substring = app_name;
    run = ["move-node-to-workspace ${workspace}"];
  };

  app_id_and_window_title_to_workspace = app_id: window_title: workspace: {
    "if".app-id = app_id;
    "if".window-title-regex-substring = window_title;
    run = ["move-node-to-workspace ${workspace}"];
  };
  workspaces = {
    Q = "Mail";
    W = "Slack";
    E = "Obsidian";
    R = "Notion";
    T = "Ticktick";
    A = "Atlas";
    S = "Comet";
    D = "Browser";
    F = "Browser-work";
    G = "G";
    Z = "Z";
    X = "X";
    C = "C";
    V = "Zed";
    B = "Terminal";
  };
in {
  programs.aerospace = {
    enable = pkgs.stdenv.isDarwin;
    launchd.enable = true;
    settings = {
      config-version = 2;

      # Trigger sketchybar update on workspace change
      exec-on-workspace-change = [
        "/bin/bash"
        "-lc"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      accordion-padding = 60;

      gaps = {
        outer.top = 32;
        outer.bottom = 0;
        outer.left = 0;
        outer.right = 0;
        inner.horizontal = 0;
        inner.vertical = 0;
      };

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      persistent-workspaces = lib.mapAttrsToList (key: name: name) workspaces;

      mode.main.binding = {
        "alt-period" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";

        "alt-h" = "focus left";
        "alt-j" = "focus down";
        "alt-k" = "focus up";
        "alt-l" = "focus right";

        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";

        "alt-minus" = "resize smart -50";
        "alt-equal" = "resize smart +50";

        "alt-q" = "workspace ${workspaces.Q}";
        "alt-w" = "workspace ${workspaces.W}";
        "alt-e" = "workspace ${workspaces.E}";
        "alt-r" = "workspace ${workspaces.R}";
        "alt-t" = "workspace ${workspaces.T}";

        "alt-a" = "workspace ${workspaces.A}";
        "alt-s" = "workspace ${workspaces.S}";
        "alt-d" = "workspace ${workspaces.D}";
        "alt-f" = "workspace ${workspaces.F}";
        "alt-g" = "workspace ${workspaces.G}";

        "alt-z" = "workspace ${workspaces.Z}";
        "alt-x" = "workspace ${workspaces.X}";
        "alt-c" = "workspace ${workspaces.C}";
        "alt-v" = "workspace ${workspaces.V}";
        "alt-b" = "workspace ${workspaces.B}";

        "alt-shift-q" = ["move-node-to-workspace ${workspaces.Q}" "workspace ${workspaces.Q}"];
        "alt-shift-w" = ["move-node-to-workspace ${workspaces.W}" "workspace ${workspaces.W}"];
        "alt-shift-e" = ["move-node-to-workspace ${workspaces.E}" "workspace ${workspaces.E}"];
        "alt-shift-r" = ["move-node-to-workspace ${workspaces.R}" "workspace ${workspaces.R}"];
        "alt-shift-t" = ["move-node-to-workspace ${workspaces.T}" "workspace ${workspaces.T}"];

        "alt-shift-a" = ["move-node-to-workspace ${workspaces.A}" "workspace ${workspaces.A}"];
        "alt-shift-s" = ["move-node-to-workspace ${workspaces.S}" "workspace ${workspaces.S}"];
        "alt-shift-d" = ["move-node-to-workspace ${workspaces.D}" "workspace ${workspaces.D}"];
        "alt-shift-f" = ["move-node-to-workspace ${workspaces.F}" "workspace ${workspaces.F}"];
        "alt-shift-g" = ["move-node-to-workspace ${workspaces.G}" "workspace ${workspaces.G}"];

        "alt-shift-z" = ["move-node-to-workspace ${workspaces.Z}" "workspace ${workspaces.Z}"];
        "alt-shift-x" = ["move-node-to-workspace ${workspaces.X}" "workspace ${workspaces.X}"];
        "alt-shift-c" = ["move-node-to-workspace ${workspaces.C}" "workspace ${workspaces.C}"];
        "alt-shift-v" = ["move-node-to-workspace ${workspaces.V}" "workspace ${workspaces.V}"];
        "alt-shift-b" = ["move-node-to-workspace ${workspaces.B}" "workspace ${workspaces.B}"];

        "alt-tab" = "workspace-back-and-forth";
        "alt-esc" = "focus-monitor --wrap-around next";
        "alt-shift-n" = "mode service";
      };

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        alt-shift-r = ["flatten-workspace-tree" "mode main"]; # reset layout
        alt-shift-f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
        backspace = ["close-all-windows-but-current" "mode main"];

        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];
      };

      on-window-detected = [
        (app_id_to_workspace "com.readdle.SparkDesktop.appstore" "Mail")
        (app_name_to_workspace "^YouTube Music$" "Mail")
        (app_id_to_workspace "com.tinyspeck.slackmacgap" "Slack")
        (app_id_to_workspace "com.hnc.Discord" "Slack")
        (app_id_to_workspace "md.obsidian" "Obsidian")
        (app_id_to_workspace "notion.id" "Notion")
        (app_id_to_workspace "com.TickTick.task.mac" "Ticktick")

        (app_id_to_workspace "com.openai.atlas" "Atlas")
        (app_id_to_workspace "ai.perplexity.comet" "Comet")
        (app_id_and_window_title_to_workspace "com.google.Chrome" "(private)" "Browser")
        (app_id_and_window_title_to_workspace "com.google.Chrome" "(work)" "Browser-work")

        (app_id_to_workspace "dev.zed.Zed" "Zed")
        (app_id_to_workspace "com.github.wez.wezterm" "Terminal")
      ];

      on-focus-changed = [
        ("exec-and-forget bash -lc 'if [ \"$(aerospace list-windows --workspace focused --count)\" -eq 1 ];"
          + " then borders width=0.0; else borders width=3.0; fi'")
      ];
    };
  };
}
