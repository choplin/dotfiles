{inputs, machines, ...}: let

  mkDarwin = name: machine: let
    rootDir = "${machine.homeDirectory}/.dotfiles";
  in
    inputs.nix-darwin.lib.darwinSystem {
      inherit (machine) system;
      specialArgs = {
        inherit rootDir;
        inherit (machine) username hostname homeDirectory;
      };
      modules = [
        ../darwin
        inputs.brew-nix.darwinModules.default
      ];
    };
in {
  flake.darwinConfigurations = builtins.mapAttrs mkDarwin machines;
}
