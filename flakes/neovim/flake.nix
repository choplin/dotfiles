{
  description = "Neovim wrapper with LSP runtime dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        config,
        system,
        ...
      }: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [inputs.neovim-nightly-overlay.overlays.default];
        };
      in {
        packages = {
          default = config.packages.neovim;
          neovim = pkgs.symlinkJoin {
            name = "neovim-with-runtimes";
            paths = [pkgs.neovim];
            nativeBuildInputs = [pkgs.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/nvim \
                --prefix PATH : ${pkgs.lib.makeBinPath [
                pkgs.nodejs
                pkgs.python3
                pkgs.go
                pkgs.rustc
                pkgs.cargo
              ]}
            '';
            meta.mainProgram = "nvim";
          };
        };
      };
    };
}
