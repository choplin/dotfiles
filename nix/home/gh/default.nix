{pkgs, ...}: let
  runtimeInputs = with pkgs; [gh fzf gawk ghq git gnugrep util-linux];
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
    (pkgs.writeShellApplication {
      name = "gh-my-issues";
      inherit runtimeInputs;
      text = builtins.readFile ./gh-my-issues.sh;
    })
  ];
}
