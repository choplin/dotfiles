{
  llm-agents,
  ...
}: {
  imports = [
    ./antigravity-cli.nix
    ./claude-code.nix
    ./codex.nix
    ./cursor-agent.nix
    ./skills.nix
  ];

  # modem-dev/hunk: terminal diff viewer for agentic changesets. Pulled prebuilt
  # from llm-agents.nix.
  home.packages = with llm-agents; [
    ctx
    herdr
    hunk
    opencode
  ];
}
