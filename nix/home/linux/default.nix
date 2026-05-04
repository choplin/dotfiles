{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./pass.nix
  ];

  config = lib.mkIf pkgs.stdenv.isLinux {
  };
}
