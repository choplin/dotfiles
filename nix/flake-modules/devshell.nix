{inputs, ...}: {
  perSystem = {pkgs, system, ...}: let
    selfTools = import ../self-tools {
      inherit inputs system;
    };
    selfToolInputNames = builtins.attrNames selfTools;
  in {
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
          name = "update-tools";
          help = "Bump self-authored tool inputs (${builtins.concatStringsSep ", " selfToolInputNames}) and rebuild";
          command = ''
            nix flake update ${pkgs.lib.escapeShellArgs selfToolInputNames}
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
