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

  # System-level packages
  environment.systemPackages = with pkgs; [
    zsh
  ];

  # Define users
  users.users.${username} = {
    home = homeDirectory;
    shell = pkgs.zsh;
  };

  # Create symlink /etc/nix-darwin -> ~/.dotfiles
  environment.etc."nix-darwin".source = "${homeDirectory}/.dotfiles";

  # Set hostname
  networking.hostName = hostname;

  # Used for backwards compatibility
  system.stateVersion = 5;

  # Enable user specific activation
  system.primaryUser = "${username}";

  imports = [
    ./homebrew.nix
  ];
}
