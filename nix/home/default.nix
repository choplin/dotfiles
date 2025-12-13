{
  config,
  pkgs,
  username,
  homeDirectory,
  rootDir,
  ...
}: {
  imports = [
    ./files.nix
  ];

  programs.home-manager.enable = true;

  # Allow `home-manager switch` without --flake
  xdg.configFile."home-manager".source = config.lib.file.mkOutOfStoreSymlink rootDir;

  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";

    # Whether to make programs use XDG directories whenever supported.
    preferXdgDirectories = true;

    packages = with pkgs; [
      ast-grep
      bandwhich
      bat
      bottom
      broot
      delta
      difftastic
      dust
      fd
      fzf
      gdu
      gh
      ghq
      git
      git-filter-repo
      glow
      gomi
      hwatch
      hexyl
      jq
      k9s
      kubectl
      lazydocker
      lazygit
      lsd
      m1ddc
      marp-cli
      minikube
      navi
      neovim
      pgcli
      procs
      pueue
      ripgrep
      sheldon
      starship
      tig
      tmux
      tokei
      treemd
      tree-sitter
      vhs
      watchexec
      yazi
      yq
      yt-dlp
      zellij
      zoxide
    ];
  };
}
