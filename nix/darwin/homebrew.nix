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
      "media-control"
      "socsieng/tap/sendkeys"
      "choplin/tap/wtm"
      "deck"
      "k1LoW/tap/mo"
    ];

    casks = [
      "1password"
      "blackhole-2ch"
      "daisydisk"
      "gitkraken-cli"
      "insta360-link-controller"
      "karabiner-elements"
      "orbstack"
      "sf-symbols"
      "typeless"
      "visual-studio-code"
    ];

    masApps = {
      Spark = 6445813049;
      LadioCast = 411213048;
      LINE = 539883307;
      "Amazon Kindle" = 302584613;
    };
  };
}
