{pkgs, ...}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "neovim-with-runtimes";
      paths = [pkgs.neovim];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/nvim \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.nodejs
          pkgs.python3
          pkgs.go
          pkgs.rustc
          pkgs.cargo
        ]}
      '';
      meta.mainProgram = "nvim";
    })
  ];
}
