{
  pkgs,
  lib,
  config,
  ...
}: let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles/nix/home/darwin/sketchybar";
in {
  # Temporary: use mkOutOfStoreSymlink for rapid iteration
  # After config is finalized, switch back to programs.sketchybar
  config = lib.mkIf pkgs.stdenv.isDarwin {
    xdg.configFile = {
      "sketchybar/sketchybarrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/sketchybarrc";
      "sketchybar/plugins".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/plugins";
    };

    home.packages = with pkgs; [
      sketchybar
      jq
    ];

    # Ensure log directory exists under XDG_STATE_HOME
    xdg.stateFile."sketchybar/.keep".text = "";

    # Background process to stream media updates to sketchybar
    launchd.agents.sketchybar-media-stream = {
      enable = true;
      config = {
        Label = "com.sketchybar.media-stream";
        ProgramArguments = ["${dotfilesDir}/plugins/media_stream.sh"];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.xdg.stateHome}/sketchybar/media-stream.log";
        StandardErrorPath = "${config.xdg.stateHome}/sketchybar/media-stream.err";
      };
    };
  };
}
