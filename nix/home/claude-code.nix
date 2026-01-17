{
  pkgs,
  pkgs-fast,
  ...
}: let
  pluginBaseDir = "$HOME/.claude/my-claude-marketplace";

  claudeWrapper = pkgs.writeShellScriptBin "claude" ''
    # Build --plugin-dir arguments dynamically
    plugin_args=()
    if [[ -d "${pluginBaseDir}" ]]; then
      for dir in "${pluginBaseDir}"/*/; do
        if [[ -d "$dir" ]]; then
          plugin_args+=(--plugin-dir "$dir")
        fi
      done
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
