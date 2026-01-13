{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.sketchybar = {
      enable = true;

      config = {
        source = ./config;  # config/ subdirectory only
        recursive = true;
      };

      extraPackages = with pkgs; [
        jq          # JSON processing (media_stream.sh, calendar_update.sh)
        gcalcli     # Google Calendar (calendar_update.sh, calendar.sh)
        treemd      # Markdown parsing (task_update.sh, task_action.sh)
        aerospace   # Workspace management (workspace.sh, app_click.sh)
      ];

      service = {
        enable = true;
        outLogFile = "${config.xdg.stateHome}/sketchybar/sketchybar.log";
        errorLogFile = "${config.xdg.stateHome}/sketchybar/sketchybar.err";
      };
    };

    # Ensure log directory exists
    xdg.stateFile."sketchybar/.keep".text = "";

    # Background process for media_stream.sh
    launchd.agents.sketchybar-media-stream = {
      enable = true;
      config = {
        Label = "com.sketchybar.media-stream";
        ProgramArguments = [
          "${config.xdg.configHome}/sketchybar/plugins/media_stream.sh"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.xdg.stateHome}/sketchybar/media-stream.log";
        StandardErrorPath = "${config.xdg.stateHome}/sketchybar/media-stream.err";
        EnvironmentVariables = {
          # media-control: /opt/homebrew/bin
          # jq, sketchybar: ${config.home.profileDirectory}/bin
          PATH = "/opt/homebrew/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin";
        };
      };
    };
  };
}
