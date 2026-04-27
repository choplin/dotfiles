{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
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
      Amphetamine = 937984704;
      Spark = 6445813049;
      LadioCast = 411213048;
      LINE = 539883307;
    };
  };
}
