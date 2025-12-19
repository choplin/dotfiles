{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
    brews = [
      "mas"
    ];

    casks = [
      "1password"
      "daisydisk"
      "karabiner-elements"
    ];

    masApps = {
      Amphetamine = 937984704;
      Spark = 6445813049;
      LadioCast = 411213048;
      LINE = 539883307;
    };
  };
}
