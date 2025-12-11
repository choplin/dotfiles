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

    mkDarwin = name: machine:
      nix-darwin.lib.darwinSystem {
        inherit (machine) system;
        specialArgs = {
          inherit (machine) username hostname homeDirectory;
        };
        modules = [
          ./nix/darwin
          brew-nix.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = overlays;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${machine.username} = import ./nix/home;
              extraSpecialArgs = {
                inherit (machine) username homeDirectory;
              };
            };
          }
        ];
      };
  in {
    darwinConfigurations = builtins.mapAttrs mkDarwin machines;
  };
}
