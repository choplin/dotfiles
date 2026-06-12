{
  description = "my nix-darwin configuration";

  # Pull prebuilt AI-agent CLIs (claude-code, codex, cursor-agent) from the
  # numtide cache instead of building them locally. Required because codex is
  # built from source upstream; cache hits depend on NOT overriding nixpkgs
  # (see the llm-agents input below, which deliberately omits `follows`).
  nixConfig = {
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

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

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    lfk = {
      url = "github:janosmiko/lfk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Prebuilt AI-agent CLIs. Intentionally does NOT follow our nixpkgs: cache
    # hits from cache.numtide.com require the exact nixpkgs llm-agents built
    # against (notably codex, which is compiled from source upstream).
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "x86_64-darwin" "x86_64-linux"];
      imports = [
        inputs.devshell.flakeModule
        ./nix/flake-modules/darwin.nix
        ./nix/flake-modules/home.nix
        ./nix/flake-modules/nixos.nix
        ./nix/flake-modules/devshell.nix
      ];
      _module.args.machines = import ./machines.nix;
    };
}
