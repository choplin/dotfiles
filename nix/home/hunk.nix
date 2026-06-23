{
  llm-agents,
  ...
}: {
  # modem-dev/hunk: terminal diff viewer for agentic changesets. Pulled prebuilt
  # from llm-agents.nix.
  home.packages = [llm-agents.hunk];
}
