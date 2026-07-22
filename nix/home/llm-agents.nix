{
  llm-agents,
  ...
}: {
  # modem-dev/hunk: terminal diff viewer for agentic changesets. Pulled prebuilt
  # from llm-agents.nix.
  home.packages = with llm-agents; [
    hunk
    opencode
  ];
}
