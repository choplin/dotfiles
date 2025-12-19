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
    ./files.nix
    ./darwin.nix
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
      claude-code
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

      # install them temporarily to install LSP servers via mason
      # Once finding the way to use locally installed LSP, stop using them.
      go
      nodejs_24
      rustc
      cargo
      alejandra
    ];
  };
}
