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
        # Read the list on FD 3, and give every `skills add` an empty stdin.
        # `skills add` consumes stdin: with the list piped in on stdin it ate the
        # remaining lines, so the loop silently stopped after the first entry and
        # only the first source was ever installed/updated. FD 3 keeps the list
        # out of its reach; </dev/null keeps it from blocking on the inherited
        # stdin (a terminal or an open pipe) now that the list is gone from there.
        while read -r package skill <&3 || [ -n "$package" ]; do
          case "$package" in "" | "#"*) continue ;; esac
          if [ -n "$skill" ]; then
            skills add "$package" --skill "$skill" -a ${agents} -g -y </dev/null
          else
            skills add "$package" -a ${agents} -g -y </dev/null
          fi
        done 3<"${listFile}"
      '';
    })
  ];
}
