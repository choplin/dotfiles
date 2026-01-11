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
  };
}
