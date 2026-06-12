{...}: {
  perSystem = {pkgs, ...}: {
    devshells.default = {
      name = "dotfiles";
      commands = [
        {
          name = "update-vendored";
          help = "Refresh vendored packages (claude-code, codex), verify, and rebuild";
          command = ''
            ./nix/packages/claude-code/update.sh
            ./nix/packages/codex/update.sh
            nix build .#claude-code .#codex
            home-manager switch --flake .
          '';
        }
        {
          name = "update-all";
          help = "Update all flake inputs and rebuild";
          command = ''
            nix flake update
            sudo darwin-rebuild switch --flake .
            home-manager switch --flake .
          '';
        }
      ];
    };
  };
}
