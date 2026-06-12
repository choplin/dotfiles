{...}: {
  perSystem = {pkgs, ...}: {
    devshells.default = {
      name = "dotfiles";
      commands = [
        {
          name = "update-agents";
          help = "Bump the llm-agents input (claude-code, codex, cursor-agent) and rebuild";
          command = ''
            nix flake update llm-agents
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
