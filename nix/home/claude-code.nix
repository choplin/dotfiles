{
  pkgs,
  pkgs-fast,
  ...
}: let
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

    exec ${pkgs-fast.claude-code}/bin/claude "''${plugin_args[@]}" "$@"
  '';
in {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "claude-code-with-runtimes";
      paths = [claudeWrapper];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/claude \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs-fast.nodejs
          pkgs-fast.bun
        ]}
      '';
      meta.mainProgram = "claude";
    })
  ];
}
