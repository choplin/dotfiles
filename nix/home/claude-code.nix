{
  pkgs,
  llm-agents,
  ...
}: let
  inherit (llm-agents) claude-code;
  claudeWrapper = pkgs.writeShellScriptBin "claude" ''
    # Build --plugin-dir arguments from config file
    plugin_args=()
    config="$HOME/.claude/my-plugins.conf"
    if [[ -f "$config" ]]; then
      while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip comments and empty lines
        [[ -z "$line" || "$line" == \#* ]] && continue
        # Tilde expansion
        expanded="''${line/#~/$HOME}"
        # Glob expand and add directories only
        for dir in $expanded; do
          [[ -d "$dir" ]] && plugin_args+=(--plugin-dir "$dir")
        done
      done < "$config"
    fi

    exec ${claude-code}/bin/claude --enable-auto-mode "''${plugin_args[@]}" "$@"
  '';
in {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "claude-code-with-runtimes";
      paths = [claudeWrapper];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        # Use the system ripgrep on PATH instead of claude's bundled copy.
        wrapProgram $out/bin/claude \
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
