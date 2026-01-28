{
  config,
  pkgs,
  username,
  homeDirectory,
  rootDir,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./claude-code.nix
    ./codex.nix
    ./darwin
    ./files.nix
    ./neovim.nix
    ./programs.nix
  ];

  programs.home-manager.enable = true;

  xdg.enable = true;

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
      devenv
      difftastic
      docker
      docker-credential-helpers
      dust
      fd
      fzf
      gcalcli
      gdu
      gemini-cli
      gh
      ghq
      gibo
      git
      git-filter-repo
      glow
      gomi
      hwatch
      hexyl
      jq
      k9s
      krew
      kubectl
      kubernetes-helm
      lazydocker
      lazygit
      lsd
      marp-cli
      minikube
      navi
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
