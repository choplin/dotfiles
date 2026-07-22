{
  llm-agents,
  ...
}: {
  # antigravity-cli ships a static Go binary (agy), so it needs no runtime
  # wrapping unlike the node/bun-based agent CLIs.
  home.packages = [llm-agents.antigravity-cli];
}
