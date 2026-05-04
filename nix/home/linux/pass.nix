{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 86400; # 24h
      maxCacheTtl = 604800; # 7 days
      pinentryPackage = pkgs.pinentry-curses;
    };

    programs.password-store = {
      enable = true;
      package = pkgs.pass;
    };
  };
}
