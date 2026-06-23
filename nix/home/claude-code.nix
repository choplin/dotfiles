{
  pkgs,
  llm-agents,
  ...
}: let
  inherit (llm-agents) claude-code;
in {
  home.packages = [
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
