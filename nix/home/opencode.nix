{
  llm-agents,
  ...
}: {
  # opencode: AI coding agent for the terminal (TUI only, no GUI).
  # Prebuilt from numtide/llm-agents.nix, served via cache.numtide.com.
  home.packages = [
    llm-agents.opencode
  ];
}
