{
  llm-agents,
  ...
}: {
  # vercel-labs/skills: the open agent skills tool for installing and managing
  # skills across AI coding agents. Pulled prebuilt from llm-agents.nix.
  home.packages = [llm-agents.skills];
}
