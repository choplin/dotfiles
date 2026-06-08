{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      # Workaround for nix-darwin#1787: Homebrew (since brew@e0d818bbb) requires
      # an explicit confirmation flag for `brew bundle install --cleanup`.
      # Remove once nix-darwin#1789 lands.
      extraFlags = ["--force-cleanup"];
    };
    brews = [
      "mas"
      "yt-dlp"
      "media-control"
      "socsieng/tap/sendkeys"
      "choplin/tap/wtm"
      "deck"
    ];

    casks = [
      "1password"
      "daisydisk"
      "gcloud-cli"
      "gitkraken-cli"
      "karabiner-elements"
      "orbstack"
      "sf-symbols"
      "typeless"
    ];

    taps = [
      "choplin/tap"
    ];

    masApps = {
      Spark = 6445813049;
      LadioCast = 411213048;
      LINE = 539883307;
    };
  };
}
