{pkgs, ...}: {
  brew-nix.enable = true;

  environment.systemPackages = with pkgs.brewCasks; [
    alt-tab
    bartender
    blackhole-2ch
    devtoys
    ghostty
    github
    gitkraken-cli
    jetbrains-toolbox
    kap
    keycastr
    notion
    notunes
    obsidian
    orbstack
    paperpile
    qlmarkdown
    qmk-toolbox
    raycast
    slack
    visual-studio-code
    zed
  ];
}
