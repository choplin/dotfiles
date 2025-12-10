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
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
  }: let
    machines = import ./machines.nix;

    mkDarwin = name: machine:
      nix-darwin.lib.darwinSystem {
        inherit (machine) system;
        specialArgs = {
          inherit (machine) username hostname homeDirectory;
        };
        modules = [
          ./nix/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${machine.username} = import ./nix/home;
            };
          }
        ];
      };
  in {
    darwinConfigurations = builtins.mapAttrs mkDarwin machines;
  };
}
