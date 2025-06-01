# Claude Code Global Memory

## Basic Configuration

### Language Settings

- Use **English** for all code comments, documentation
- Use **Japanese** for chat responses
- When user instructs in English, correct any grammatical errors or unnatural expressions after completing the work, without interrupting the workflow

### Core Principles

- Do what has been asked; nothing more, nothing less
- Never create files unless necessary; prefer editing existing files
- NEVER proactively create documentation (*.md) or README files unless explicitly requested
- Always propose a plan before starting actual work and wait for user confirmation
- Prioritize test-first development approach whenever possible
- Do not create a git commit unless explicitly requested

## Development Workflow

### Standard Process

When user describes a new issue or feature to work on:

1. **Understand the requirements**
2. **Plan the implementation**
3. **Set up branch** (use `~/.claude/scripts/setup-worktree.sh <branch-name>`)
4. **Document context and plan** in worktree CLAUDE.md (background, requirements, implementation plan)
5. **Begin implementation** in the new worktree

### Pull Request Workflow

- When asked to create a PR, draft description in `pr-description.md` at repository root
- Do not create actual PR unless explicitly requested

### Git Workflow

- Use git worktree: `{repo_root}/.worktrees/{branch_name}/`
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

**DO NOT include Claude attribution** (e.g., "Generated with Claude Code" or "Co-Authored-By: Claude").

## Technical Configuration

### File Formatting

- File formatting (newlines, trailing whitespace) handled automatically by pre-commit hooks

### Command Preferences

- Use `rg` (ripgrep) instead of `grep` for searching file contents
- Use `fd` instead of `find` for finding files and directories
- Avoid using bash search commands; use Grep, Glob, or Task tools instead

## Filetype Specific Rules

### Markdown Files

- ALWAYS insert blank line before and after headings and lists

## Automation Scripts

- Use `~/.claude/scripts/setup-worktree.sh <branch-name>` to set up branches
- Use `~/.claude/scripts/pr-checkout.sh <pr-number>` to checkout PR and create worktree
- Use `~/.claude/scripts/rebase-branch.sh <original-branch> <commit-range>` to rebase from main
- Use `~/.claude/scripts/notify.sh [message] [title]` to send desktop notifications
