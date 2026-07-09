{ ... }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      # Workaround for nix-darwin#1787: Homebrew (since brew@e0d818bbb) requires
      # an explicit confirmation flag for `brew bundle install --cleanup`.
      # Remove once nix-darwin#1789 lands.
      extraFlags = [ "--force-cleanup" ];
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
      # Apps that failed to install cleanly via brew-nix (nix store).
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

      # Apps we let self-update, installed as real writable bundles.
      #
      # Placement rule (counterpart of brew-nix.nix): keep an app here when we
      # want it to track upstream on its own. Homebrew installs a real .app in
      # /Applications so its built-in updater works, and it skips these on
      # `brew upgrade` because their cask sets `auto_updates true` (we also do
      # not enable onActivation.upgrade). Criteria to move an app here:
      #   - its Homebrew cask has `auto_updates: true`, AND
      #   - we actually want it to follow upstream (editors, AI, chat, notes),
      #     rather than staying pinned by nix.
      "chatgpt-atlas"
      "claude"
      "cleanshot"
      "codex-app"
      "cursor"
      "discord"
      "ghostty"
      "linear"
      "notion"
      "obsidian"
      "stablyai/orca/orca"
      "raycast"
      "slack"
      "superwhisper"
      "zed"
    ];

    masApps = {
      Spark = 6445813049;
      LadioCast = 411213048;
      LINE = 539883307;
      "Amazon Kindle" = 302584613;
    };
  };
}
