{
  pkgs,
  username,
  hostname,
  homeDirectory,
  rootDir,
  ...
}: {
  # Let Determinate manage Nix
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define users
  users.users.${username} = {
    home = homeDirectory;
  };

  # Set hostname
  networking.hostName = hostname;

  # Used for backwards compatibility
  system.stateVersion = 5;

  # Enable user specific activation
  system.primaryUser = "${username}";

  # Create symlink /etc/nix-darwin -> ~/.dotfiles
  environment.etc."nix-darwin".source = rootDir;

  environment.systemPackages = with pkgs; [
    _1password-gui
    #daisydisk
    google-chrome
    google-cloud-sdk
  ];

  fonts.packages = with pkgs; [
    hackgen-font
    hackgen-nf-font
    plemoljp
    plemoljp-nf
    plemoljp-hs
    udev-gothic
    udev-gothic-nf
  ];

  imports = [
    ./homebrew.nix
    ./brew-nix.nix
    ./system.nix
  ];
}
