{
  pkgs,
  lib,
  llm-agents,
  ...
}: let
  # External skills installed from other repos/gists via the skills CLI.
  # `skill` is optional: omit it to let the CLI install the source default
  # (a single-skill gist); use "*" to install every skill under a repo's skills/.
  externalSkills = [
    {
      package = "vercel-labs/skills";
      skill = "*";
    }
    {
      package = "choplin/wtm";
      skill = "*";
    }
    {package = "https://gist.github.com/fd287c3133457c4fd8f5601d34aa817d.git";}
  ];

  # skills-CLI agent ids and scope to install the external skills for.
  agents = "claude-code codex";

  toCmd = s:
    "skills add ${s.package}"
    + lib.optionalString (s ? skill) " --skill '${s.skill}'"
    + " -a ${agents} -g -y";
in {
  home.packages = [
    # vercel-labs/skills: the open agent skills tool for installing and managing
    # skills across AI coding agents. Pulled prebuilt from llm-agents.nix.
    llm-agents.skills

    # install-external-skills: (re)install the external skills declared above.
    # Declaration lives here; run the command on demand to apply it.
    (pkgs.writeShellApplication {
      name = "install-external-skills";
      runtimeInputs = [llm-agents.skills];
      text = lib.concatMapStringsSep "\n" toCmd externalSkills;
    })
  ];
}
