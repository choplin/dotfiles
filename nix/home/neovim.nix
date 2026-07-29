{pkgs, lib, ...}: let
  editorTools = import ./editor-language-tools.nix {inherit pkgs lib;};

  # Shared common-language tools only. Editor-specific extras go here.
  # Treesitter parser/query assets are owned by a separate Neovim closure,
  # not by this PATH catalog.
  neovimTools = editorTools.mkEditorToolsEnv {
    name = "neovim-language-tools";
    languages = editorTools.commonLanguages;
    extraPackages = [];
  };
in {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "neovim-with-runtimes";
      paths = [pkgs.neovim];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/nvim \
          --suffix PATH : ${neovimTools}/bin
      '';
      meta.mainProgram = "nvim";
    })
  ];
}
