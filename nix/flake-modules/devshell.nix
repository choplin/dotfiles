{...}: {
  perSystem = {pkgs, ...}: {
    devshells.default = {
      name = "dotfiles";
      commands = [
        {
          name = "update-fast";
          help = "Update nixpkgs-fast packages and rebuild";
          command = ''
            nix flake update nixpkgs-fast
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
