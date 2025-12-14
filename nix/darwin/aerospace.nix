{...}: let
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
in {
  services.aerospace = {
    enable = true;
    settings = {
      config-version = 2;

      accordion-padding = 60;

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      persistent-workspaces = [
        "Mail" # Q
        "Slack" # W
        "Obsidian" # E
        "R"
        "T"

        "Atlas" # A
        "S"
        "Comet" # D
        "Browser" # F
        "Browser-work" # G

        "Z"
        "X"
        "C"
        "Zed" # V
        "Terminal" # B
      ];

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

        "alt-q" = "workspace Mail";
        "alt-w" = "workspace Slack";
        "alt-e" = "workspace Obsidian";
        "alt-r" = "workspace R";
        "alt-t" = "workspace T";

        "alt-a" = "workspace Atlas";
        "alt-s" = "workspace S";
        "alt-d" = "workspace Comet";
        "alt-f" = "workspace Browser";
        "alt-g" = "workspace Browser-work";

        "alt-z" = "workspace Z";
        "alt-x" = "workspace X";
        "alt-c" = "workspace C";
        "alt-v" = "workspace Zed";
        "alt-b" = "workspace Terminal";

        "alt-shift-q" = "move-node-to-workspace Mail";
        "alt-shift-w" = "move-node-to-workspace Slack";
        "alt-shift-e" = "move-node-to-workspace Obsidian";
        "alt-shift-r" = "move-node-to-workspace R";
        "alt-shift-t" = "move-node-to-workspace T";

        "alt-shift-a" = "move-node-to-workspace Atlas";
        "alt-shift-s" = "move-node-to-workspace S";
        "alt-shift-d" = "move-node-to-workspace Comet";
        "alt-shift-f" = "move-node-to-workspace Browser";
        "alt-shift-g" = "move-node-to-workspace Browser-work";

        "alt-shift-z" = "move-node-to-workspace Z";
        "alt-shift-x" = "move-node-to-workspace X";
        "alt-shift-c" = "move-node-to-workspace C";
        "alt-shift-v" = "move-node-to-workspace Zed";
        "alt-shift-b" = "move-node-to-workspace Terminal";

        "alt-tab" = "workspace-back-and-forth";
        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
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
