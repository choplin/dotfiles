{...}: {
  system.defaults.finder = {
    # Show all file extensions
    AppleShowAllExtensions = true;

    # Show hidden files (files starting with .)
    AppleShowAllFiles = true;

    # Hide desktop icons
    CreateDesktop = false;

    # Disable warning when changing file extension
    FXEnableExtensionChangeWarning = false;

    # Show path bar at the bottom of Finder windows
    ShowPathbar = true;

    # Show status bar at the bottom of Finder windows
    ShowStatusBar = true;
  };

  system.defaults.dock = {
    # Auto-hide the Dock
    autohide = true;

    # Hide recent applications
    show-recents = false;

    # Dock icon size in pixels
    tilesize = 30;

    # Enable icon magnification on hover
    magnification = true;

    # Magnified icon size in pixels
    largesize = 69;

    # Dock position: "bottom", "left", or "right"
    orientation = "bottom";

    # Window minimize effect: "scale" or "genie"
    mineffect = "scale";

    # Disable app launch animation
    launchanim = false;

    # Launch quick notes on the bottom right corner
    wvous-br-corner = 14;
  };
}
