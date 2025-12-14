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

    # Whether to group windows by application in Mission Control's Exposé.
    # Recommended for aerospace
    expose-group-apps = true;
  };

  system.defaults.controlcenter = {
    # Apple menu > System Preferences > Control Center > Battery. Show a battery percentage in menu bar.
    BatteryShowPercentage = true;
    # Apple menu > System Preferences > Control Center > Bluetooth. Show a bluetooth control in menu bar.
    Bluetooth = false;
    # Apple menu > System Preferences > Control Center > Display. Show a Screen Brightness control in menu bar
    Display = false;
  };

  system.defaults.NSGlobalDomain = {
    # Use F1, F2, etc. keys as standard function keys.
    "com.apple.keyboard.fnState" = true;
    # Configures the trackpad tap behavior. Mode 1 enables tap to click.
    "com.apple.mouse.tapBehavior" = 1;
    # Whether to enable "Natural" scrolling direction. The default is true.
    "com.apple.swipescrolldirection" = false;
    # Whether to enable trackpad secondary click. The default is true.
    "com.apple.trackpad.enableSecondaryClick" = true;
    # Whether to enable trackpad force click.
    "com.apple.trackpad.forceClick" = true;
    # How long you must hold down the key before it starts repeating.
    InitialKeyRepeat = 15;
    # How fast it repeats once it starts.
    KeyRepeat = 2;
  };

  system.defaults.".GlobalPreferences" = {
    "com.apple.mouse.scaling" = 0.5;
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };
}
