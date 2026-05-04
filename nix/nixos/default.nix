{username, hostname, homeDirectory, ...}: {
  wsl.enable = true;
  wsl.defaultUser = username;

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    home = homeDirectory;
  };

  networking.hostName = hostname;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.05";
}
