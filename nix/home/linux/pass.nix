{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 604800; # 7 days
      maxCacheTtl = 604800; # 7 days
      # Stay in the terminal.  pinentry-curses draws a bordered box and aborts
      # with "Screen or window too small" below roughly 10x50; pinentry-tty
      # prompts on a plain line and has no size requirement.
      pinentry.package = pkgs.pinentry-tty;
    };

    programs.password-store = {
      enable = true;
      package = pkgs.pass;
    };
  };
}
