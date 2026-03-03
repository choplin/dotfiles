{pkgs, ...}: let
  runtimeInputs = with pkgs; [gh fzf gawk];
in {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "gh-review-requests";
      inherit runtimeInputs;
      text = builtins.readFile ./gh-review-requests.sh;
    })
    (pkgs.writeShellApplication {
      name = "gh-my-prs";
      inherit runtimeInputs;
      text = builtins.readFile ./gh-my-prs.sh;
    })
  ];
}
