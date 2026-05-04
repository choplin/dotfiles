{inputs, lib, machines, ...}: let

  linuxMachines = lib.filterAttrs (_: m: lib.hasSuffix "-linux" m.system) machines;

  mkNixos = name: machine: let
    rootDir = "${machine.homeDirectory}/.dotfiles";
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit (machine) system;
      specialArgs = {
        inherit rootDir;
        inherit (machine) username hostname homeDirectory;
      };
      modules = [
        ../nixos
        inputs.nixos-wsl.nixosModules.default
      ];
    };
in {
  flake.nixosConfigurations = builtins.mapAttrs mkNixos linuxMachines;
}
