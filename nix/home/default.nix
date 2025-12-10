{
  pkgs,
  username,
  homeDirectory,
  ...
}: {
  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";

    packages = with pkgs; [
      # Add user packages here
    ];
  };

  programs.home-manager.enable = true;
}
