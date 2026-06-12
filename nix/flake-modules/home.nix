{inputs, machines, ...}: let

  mkHome = name: machine: let
    rootDir = "${machine.homeDirectory}/.dotfiles";
    system = machine.system;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [inputs.neovim-nightly-overlay.overlays.default];
      };
      extraSpecialArgs = {
        inherit rootDir;
        inherit (machine) username homeDirectory;
        lfk = inputs.lfk.packages.${system}.default;
        # Prebuilt AI-agent CLIs (claude-code, codex, cursor-agent) from
        # numtide/llm-agents.nix, served via cache.numtide.com.
        llm-agents = inputs.llm-agents.packages.${system};
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
