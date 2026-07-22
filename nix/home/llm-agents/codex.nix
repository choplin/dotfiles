{
  pkgs,
  llm-agents,
  ...
}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "codex-with-runtimes";
      paths = [llm-agents.codex];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = let
        runtimeDeps = pkgs.lib.makeBinPath [
          pkgs.nodejs
          pkgs.bun
        ];
      in ''
        # llm-agents' codex does not disable its self-updater; the read-only
        # Nix store would make an update fail, so suppress it explicitly.
        wrapProgram $out/bin/codex \
          --prefix PATH : ${runtimeDeps} \
          --set DISABLE_AUTOUPDATER 1

        # codex-xhigh: reasoning effort xhigh
        cat > $out/bin/codex-xhigh << 'EOF'
#!/usr/bin/env bash
exec "$(dirname "$0")/codex" --config model_reasoning_effort="xhigh" "$@"
EOF
        chmod +x $out/bin/codex-xhigh

        # codex-medium: reasoning effort medium
        cat > $out/bin/codex-medium << 'EOF'
#!/usr/bin/env bash
exec "$(dirname "$0")/codex" --config model_reasoning_effort="medium" "$@"
EOF
        chmod +x $out/bin/codex-medium
      '';
      meta.mainProgram = "codex";
    })
  ];
}
