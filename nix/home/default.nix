{
  config,
  pkgs,
  username,
  homeDirectory,
  rootDir,
  lfk,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./claude-sessions.nix
    ./darwin
    ./files.nix
    ./gh
    ./kimi-code
    ./linux
    ./llm-agents
    ./neovim.nix
    ./programs.nix
    ./zed.nix
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

    packages = (with pkgs; [
      #ast-grep
      agent-browser
      bandwhich
      bat
      bottom
      broot
      bun
      delta
      devenv
      difftastic
      docker
      docker-credential-helpers
      dust
      fd
      ffmpeg
      fzf
      gcalcli
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        cloud-sql-proxy
        gcloud-crc32c
      ]))
      gdu
      gh
      ghq
      gibo
      git
      git-filter-repo
      glow
      gomi
      hwatch
      hexyl
      jira-cli-go
      jq
      k9s
      krew
      kubectl
      # kubernetes-helm  # FIXME: nixpkgs 4.2.0 build broken (checkPhase substitutes nonexistent cmd/helm/dependency_build_test.go); re-enable when fixed upstream
      lazydocker
      lazygit
      lsd
      marp-cli
      minikube
      mosh
      navi
      pgcli
      poppler-utils
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
      voicevox-engine
      watchexec
      wget
      # Build with nodejs_22: default nodejs_24 crashes wrangler's tsup build
      # with `EBADF: bad file descriptor, fstat`. Drop the override once upstream
      # nixpkgs builds cleanly on the default node.
      (wrangler.override {nodejs = nodejs_22;})
      yazi
      yq
      yt-dlp
      zellij
      zk
      zoxide
    ]) ++ [
      lfk
    ];
  };
}
