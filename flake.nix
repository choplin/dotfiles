{
  description = "my nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.brew-api.follows = "brew-api";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nix-darwin,
    home-manager,
    brew-nix,
    ...
  }: let
    machines = import ./machines.nix;

    mkDarwin = name: machine: let
      rootDir = "${machine.homeDirectory}/.dotfiles";
    in
      nix-darwin.lib.darwinSystem {
        inherit (machine) system;
        specialArgs = {
          inherit rootDir;
          inherit (machine) username hostname homeDirectory;
        };
        modules = [
          ./nix/darwin
          brew-nix.darwinModules.default
        ];
      };
    mkHome = name: machine: let
      rootDir = "${machine.homeDirectory}/.dotfiles";
      system = machine.system;
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [inputs.neovim-nightly-overlay.overlays.default];
        };
        extraSpecialArgs = {
          inherit rootDir;
          inherit (machine) username homeDirectory;
        };
        modules = [./nix/home];
      };
    # Rekeyed machines with "username@hostname" for homeConfigurations
    homeMachines = builtins.listToAttrs (
      builtins.map (name: {
        name = "${machines.${name}.username}@${machines.${name}.hostname}";
        value = machines.${name};
      }) (builtins.attrNames machines)
    );
  in {
    darwinConfigurations = builtins.mapAttrs mkDarwin machines;
    homeConfigurations = builtins.mapAttrs mkHome homeMachines;
  };
}
