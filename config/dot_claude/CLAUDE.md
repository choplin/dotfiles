# Claude Code Instructions

@~/.agents/AGENTS.md

## Claude Code Specific Instructions

- If `gh` fails with a TLS error inside the Claude Code sandbox while the same operation works outside it, treat the sandbox as the likely cause. Retry the scoped command with `dangerouslyDisableSandbox: true`.
