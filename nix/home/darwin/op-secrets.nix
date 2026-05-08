{
  pkgs,
  lib,
  ...
}: let
  # How to add a new secret:
  #   1. Create an "API Credential" item in the 1Password "Secrets" vault:
  #        op item create --vault Secrets --category "API Credential" \
  #          --title "My Token" --field credential="<token-value>"
  #   2. Add an entry below: ENV_VAR_NAME = "op://Secrets/My Token/credential";
  #   3. Run `home-manager switch` to regenerate the template
  #   4. Run `op-secrets-refresh` in your shell to update the cache
  secrets = {
    JIRA_API_TOKEN = "op://Secrets/Jira API Token/credential";
  };

  templateLines = lib.mapAttrsToList
    (name: ref: ''export ${name}="{{ ${ref} }}"'')
    secrets;

  templateContent = lib.concatStringsSep "\n" templateLines + "\n";
in {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    xdg.dataFile."zsh/op-secrets.tpl".text = templateContent;
  };
}
