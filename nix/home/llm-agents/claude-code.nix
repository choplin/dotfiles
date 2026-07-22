{
  pkgs,
  llm-agents,
  ...
}: let
  inherit (llm-agents) claude-code claude-agent-acp;
in {
  home.packages = [
    # ACP server for Zed's external agent, wrapped so it inherits the repo's
    # nix flake + direnv environment. Zed's `claude-acp` agent_server points at
    # this by bare name (resolved via PATH on terminal launch).
    #
    # Env resolution, deterministically from git (not just $PWD):
    #   1. current worktree's own .envrc (via --show-toplevel), else
    #   2. the main worktree's .envrc (via --git-common-dir), where an
    #      uncommitted .envrc typically lives when working from a worktree.
    (pkgs.writeShellApplication {
      name = "claude-agent-acp-direnv";
      runtimeInputs = [pkgs.direnv pkgs.git];
      text = ''
        envrc_dir=""

        top=$(git rev-parse --show-toplevel 2>/dev/null || true)
        if [ -n "$top" ] && [ -f "$top/.envrc" ]; then
          envrc_dir="$top"
        else
          common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)
          if [ -n "$common" ] && [ -f "''${common%/*}/.envrc" ]; then
            envrc_dir="''${common%/*}"
          fi
        fi

        # Call the ACP server by absolute store path: under `direnv exec` the
        # command is resolved against the devshell's PATH, which does not
        # contain it. The binary hardcodes its own node, so no PATH is needed.
        acp=${claude-agent-acp}/bin/claude-agent-acp
        if [ -n "$envrc_dir" ]; then
          exec direnv exec "$envrc_dir" "$acp" "$@"
        fi
        exec "$acp" "$@"
      '';
    })
    (pkgs.symlinkJoin {
      name = "claude-code-with-runtimes";
      paths = [claude-code];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        # Use the system ripgrep on PATH instead of claude's bundled copy.
        wrapProgram $out/bin/claude \
          --add-flags --enable-auto-mode \
          --set USE_BUILTIN_RIPGREP 0 \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.nodejs
          pkgs.bun
          pkgs.ripgrep
        ]}
      '';
      meta.mainProgram = "claude";
    })
  ];
}
