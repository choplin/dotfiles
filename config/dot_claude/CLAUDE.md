# Claude Code Global Memory

@~/.agents/AGENTS.md

## Claude Code Specific Instructions

### Commands & Tools

- **`gh` command TLS errors** - `gh` コマンドでTLSエラーが発生した場合、Claude Codeのsandboxが原因。`dangerouslyDisableSandbox: true` で再実行すること

### Language-Specific Settings

Language-specific configurations and best practices are stored in separate files in the `$HOME/.claude/languages/` directory:

- **TypeScript**: `typescript.md`
- **Python**: `python.md`
- **Java**: `java.md`
- **Scala**: `scala.md`
- **Go**: `go.md`

Each language file contains specific tooling preferences, coding conventions, and best practices for that language.
