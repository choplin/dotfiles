{pkgs, ...}: {
  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      # Add user packages here
    ];
  };

  programs.home-manager.enable = true;
}
