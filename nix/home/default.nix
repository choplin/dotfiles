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
    ./antigravity-cli.nix
    ./claude-code.nix
    ./claude-sessions.nix
    ./codex.nix
    ./cursor-agent.nix
    ./darwin
    ./files.nix
    ./gh
    ./hunk.nix
    ./kimi-code
    ./linux
    ./neovim.nix
    ./opencode.nix
    ./programs.nix
    ./skills.nix
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
      poppler
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
      yazi
      yq
      yt-dlp
      zellij
      zoxide
    ]) ++ [
      lfk
    ];
  };
}
