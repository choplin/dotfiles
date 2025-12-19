{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    targets.darwin.defaults.NSGlobalDomain = {
      AppleLanguages = ["en-JP" "ja-JP"];
      AppleLocale = "en_JP";
    };

    home.packages = with pkgs; [
      m1ddc
    ];
  };
}
