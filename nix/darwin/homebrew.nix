{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };

    casks = [
      "daisydisk"
      "karabiner-elements"
    ];
  };
}
