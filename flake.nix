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

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    flake-parts.url = "github:hercules-ci/flake-parts";

    neovim-wrapped = {
      url = "path:./flakes/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.neovim-nightly-overlay.follows = "neovim-nightly-overlay";
    };
  };

  outputs = inputs @ {
    nix-darwin,
    home-manager,
    brew-nix,
    ...
  }: let
    machines = import ./machines.nix;

    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];

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
          inherit overlays;
        };
        extraSpecialArgs = {
          inherit rootDir;
          inherit (machine) username homeDirectory;
          neovim-wrapped = inputs.neovim-wrapped.packages.${system}.default;
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
