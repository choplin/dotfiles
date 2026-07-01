{pkgs, ...}: {
  brew-nix.enable = true;

  # Apps pinned by nix for reproducibility.
  #
  # Placement rule (see homebrew.nix for the counterpart):
  #   brew-nix here symlinks each .app from the read-only nix store, so an
  #   app's own updater cannot write to its bundle. Keep an app here only when
  #   we do NOT want it to track upstream on its own:
  #     - `auto_updates` is null in its Homebrew cask (no self-updater), or
  #     - it self-updates but is a rarely-changing utility we prefer to pin.
  #   Apps we want to self-update live in homebrew.nix casks instead.
  environment.systemPackages = with pkgs.brewCasks; [
    bartender
    contexts
    deskpad
    devtoys
    drawio
    elgato-stream-deck
    github
    kap
    keycastr
    notunes
    paperpile
    qlmarkdown
    qmk-toolbox
  ];
}
