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

    packages = with pkgs; [
      m1ddc
    ];
  };
}
