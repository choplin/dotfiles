{pkgs, ...}: {
  brew-nix.enable = true;

  environment.systemPackages = with pkgs.brewCasks; [
    bartender
    blackhole-2ch
    chatgpt-atlas
    cleanshot
    contexts
    deskpad
    devtoys
    discord
    drawio
    elgato-stream-deck
    ghostty
    github
    gitkraken
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
    superwhisper
    ticktick
    visual-studio-code
    zed
  ];
}
