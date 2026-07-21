{
  config,
  pkgs,
  rootDir,
  llm-agents,
  ...
}: let
  # External skills are declared in a repo-managed list file symlinked into
  # ~/.config, so edits apply without a home-manager switch.
  listFile = "${config.xdg.configHome}/skills/external-skills.txt";

  # skills-CLI agent ids and scope to install the external skills for.
  agents = "claude-code codex";
in {
  # ~/.config/skills/external-skills.txt -> config/dot_config/skills/external-skills.txt
  xdg.configFile."skills/external-skills.txt".source =
    config.lib.file.mkOutOfStoreSymlink
    "${rootDir}/config/dot_config/skills/external-skills.txt";

  home.packages = [
    # vercel-labs/skills: the open agent skills tool for installing and managing
    # skills across AI coding agents. Pulled prebuilt from llm-agents.nix.
    llm-agents.skills

    # install-external-skills: (re)install the external skills declared in the
    # list file. Run the command on demand to apply changes to the list.
    (pkgs.writeShellApplication {
      name = "install-external-skills";
      runtimeInputs = [llm-agents.skills];
      text = ''
        while read -r package skill || [ -n "$package" ]; do
          case "$package" in "" | "#"*) continue ;; esac
          if [ -n "$skill" ]; then
            skills add "$package" --skill "$skill" -a ${agents} -g -y
          else
            skills add "$package" -a ${agents} -g -y
          fi
        done <"${listFile}"
      '';
    })
  ];
}
