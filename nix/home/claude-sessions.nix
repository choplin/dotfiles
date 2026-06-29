{pkgs, ...}: {
  # Save/restore running Claude Code sessions. Distributed via Nix so the
  # binary and its runtime dependencies are reproducible (no manual symlink).
  # Source: config/scripts/claude-sessions
  home.packages = [
    (pkgs.writeShellApplication {
      name = "claude-sessions";
      runtimeInputs = with pkgs; [
        jq
        fzf
        coreutils
        findutils
        gnugrep
        util-linux
      ];
      text = builtins.readFile ../../config/scripts/claude-sessions;
    })
  ];
}
