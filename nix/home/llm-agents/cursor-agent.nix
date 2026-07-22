{
  pkgs,
  llm-agents,
  ...
}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "cursor-agent-with-runtimes";
      paths = [llm-agents.cursor-agent];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = let
        runtimeDeps = pkgs.lib.makeBinPath [
          pkgs.nodejs
          pkgs.bun
        ];
      in ''
        wrapProgram $out/bin/cursor-agent \
          --prefix PATH : ${runtimeDeps}
      '';
      meta.mainProgram = "cursor-agent";
    })
  ];
}
