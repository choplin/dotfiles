{
  pkgs,
  lib,
  ...
}: let
  scriptsDir = ../../../config/scripts/darwin;
in {
  # imports cannot be conditional.
  # Each module is responsible for making itself darwin-only via `enable = pkgs.stdenv.isDarwin`.
  imports = [
    ./aerospace.nix
    ./sketchybar
  ];

  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.defaults.NSGlobalDomain = {
      AppleLanguages = ["en-JP" "ja-JP"];
      AppleLocale = "en_JP";
    };

    home.packages = with pkgs; [
      m1ddc
    ];

    # macOS-only scripts
    xdg.dataFile = {
      "streamdeck/scripts" = {
        source = "${scriptsDir}/streamdeck/scripts";
        recursive = true;
        executable = true;
      };
      "raycast/scripts" = {
        source = "${scriptsDir}/raycast/scripts";
        recursive = true;
        executable = true;
      };
    };
  };
}
