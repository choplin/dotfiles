{pkgs, ...}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "claude-code-with-runtimes";
      paths = [pkgs.claude-code];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/claude \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.nodejs
        ]}
      '';
      meta.mainProgram = "claude";
    })
  ];
}
