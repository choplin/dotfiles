{
  pkgs,
  username,
  hostname,
  homeDirectory,
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

  # Create symlink /etc/nix-darwin -> ~/.dotfiles
  environment.etc."nix-darwin".source = "${homeDirectory}/.dotfiles";

  # Set hostname
  networking.hostName = hostname;

  # Used for backwards compatibility
  system.stateVersion = 5;

  # Enable user specific activation
  system.primaryUser = "${username}";

  environment.systemPackages = [
    pkgs._1password-gui
    pkgs.daisydisk
    pkgs.google-chrome
    pkgs.google-cloud-sdk
  ];

  imports = [
    ./homebrew.nix
    ./brew-nix.nix
  ];
}
