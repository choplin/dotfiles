{pkgs, username, hostname, homeDirectory, rootDir, ...}: {
  wsl.enable = true;
  wsl.defaultUser = username;

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  users.users.${username} = {
    home = homeDirectory;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
  };

  networking.hostName = hostname;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Create symlink /etc/nixos -> ~/.dotfiles
  environment.etc."nixos".source = rootDir;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  system.stateVersion = "25.05";
}
