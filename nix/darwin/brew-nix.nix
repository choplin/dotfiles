{pkgs, ...}: {
  brew-nix.enable = true;

  environment.systemPackages = with pkgs.brewCasks; [
    bartender
    blackhole-2ch
    chatgpt-atlas
    cleanshot
    contexts
    devtoys
    discord
    elgato-stream-deck
    ghostty
    github
    gitkraken-cli
    insta360-link-controller
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
