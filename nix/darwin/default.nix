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

  # Create symlink /etc/nix-darwin -> ~/.dotfiles/nix
  system.activationScripts.postActivation.text = ''
    if [ -L /etc/nix-darwin ]; then
      rm /etc/nix-darwin
    elif [ -e /etc/nix-darwin ]; then
      echo "Warning: /etc/nix-darwin exists and is not a symlink"
      exit 1
    fi
    ln -s ${homeDirectory}/.dotfiles /etc/nix-darwin
    echo "Created symlink: /etc/nix-darwin -> ${homeDirectory}/.dotfiles"
  '';

  # Set hostname
  networking.hostName = hostname;

  # Used for backwards compatibility
  system.stateVersion = 5;
}
