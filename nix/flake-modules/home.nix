{inputs, machines, ...}: let

  mkHome = name: machine: let
    rootDir = "${machine.homeDirectory}/.dotfiles";
    system = machine.system;
    pkgs-fast = import inputs.nixpkgs-fast {
      inherit system;
      config.allowUnfree = true;
    };
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [inputs.neovim-nightly-overlay.overlays.default];
      };
      extraSpecialArgs = {
        inherit rootDir pkgs-fast;
        inherit (machine) username homeDirectory;
      };
      modules = [../home];
    };

  # Rekeyed machines with "username@hostname" for homeConfigurations
  homeMachines = builtins.listToAttrs (
    builtins.map (name: {
      name = "${machines.${name}.username}@${machines.${name}.hostname}";
      value = machines.${name};
    }) (builtins.attrNames machines)
  );
in {
  flake.homeConfigurations = builtins.mapAttrs mkHome homeMachines;
}
