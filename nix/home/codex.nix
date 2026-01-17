{
  pkgs,
  pkgs-fast,
  ...
}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "codex-with-runtimes";
      paths = [pkgs-fast.codex];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = let
        runtimeDeps = pkgs.lib.makeBinPath [
          pkgs-fast.nodejs
          pkgs-fast.bun
        ];
      in ''
        wrapProgram $out/bin/codex \
          --prefix PATH : ${runtimeDeps}

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
