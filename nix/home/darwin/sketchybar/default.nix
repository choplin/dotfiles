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

    # Background process to stream media updates to sketchybar
    launchd.agents.sketchybar-media-stream = {
      enable = true;
      config = {
        Label = "com.sketchybar.media-stream";
        ProgramArguments = ["${dotfilesDir}/plugins/media_stream.sh"];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/sketchybar-media-stream.log";
        StandardErrorPath = "/tmp/sketchybar-media-stream.err";
      };
    };
  };
}
