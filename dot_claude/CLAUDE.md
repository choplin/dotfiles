# Claude Code Global Memory

## Core Instructions

### Language

- Use **English** for all code comments, documentation
- Use **Japanese** for chat responses

### File Management

- Do what has been asked; nothing more, nothing less
- Never create files unless necessary; prefer editing existing files
- NEVER proactively create documentation (*.md) or README files unless explicitly requested

### File Formatting

- ALWAYS insert blank line after headings and lists in Markdown files
- ALWAYS add newline at end of all text files
- DO NOT allow trailing white spacing in each line

### Development Workflow

When user describes a new issue or feature to work on:

1. **Understand the requirements**
2. **Plan the implementation**
3. **Set up branch** (use `~/.claude/scripts/setup-worktree.sh <branch-name>`)
4. **Begin implementation** in the new worktree

### Git Workflow

- Use git worktree: `{repo_root}/.worktrees/{repo_name}-{branch_name}/`
- For new CLAUDE.md in subdirectories: create in original tree, symlink in worktree

### Commit Messages

Follow conventional commit style with single-line messages:

- `feat(module): add new feature`
- `fix(module): fix bug description`
- `refactor(module): refactor description`
- `build(module): build system changes`
- `docs(module): documentation updates`
- `test(module): test changes`
- `chore(module): maintenance tasks`

Module name is optional for changes affecting entire project.

## Common Commands

### Command Preferences

- Use `rg` (ripgrep) instead of `grep` for searching file contents
- Use `fd` instead of `find` for finding files and directories
- Avoid using bash search commands; use Grep, Glob, or Task tools instead

## Project-Specific Information

<!-- Add project-specific information here -->

## Automation Scripts

- Use `~/.claude/scripts/setup-worktree.sh <branch-name>` to set up branches
- Use `~/.claude/scripts/fix-newlines.sh [directory]` to ensure all files end with newline
- Use `~/.claude/scripts/fix-trailing-whitespace.sh [directory]` to remove trailing whitespace

<!-- Add more workflow automation scripts here -->
