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
    };
  };
}
