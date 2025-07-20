---
allowed-tools: Bash(git *, rm), Read, LS, TodoWrite, mcp__vault__vault_get, mcp__vault__vault_list
description: Resume work from previously saved context
---

# Resume Workspace

This command resumes work from a previously suspended workspace session.

## Context Location

The work context will be retrieved from:

1. **Primary**: vault MCP with key `work-context` (branch scope)
2. **Legacy fallback**: If not found in vault, check for old file-based storage:
   - Git repository root: `{repo_root}/.claude/context/work-context.md`
   - Current directory: `./.claude/context/work-context.md`

## Process

I will:

1. **Check for saved context**:
   - First, try to retrieve from vault using `mcp__vault__vault_get` with key `work-context`
   - If not found, check for legacy file-based storage:
     - If in git repository, use `git rev-parse --show-toplevel` to find repo root
     - Check for `.claude/context/work-context.md` in the appropriate location

2. **Load the context**:
   - If found in vault, use the retrieved content directly
   - If found as legacy file, read the file and optionally migrate to vault

3. **Display workspace information**:
   - Use git commands (`git status`, `git branch`) if in a git repository
   - Show current directory path

4. **Summarize understanding**: After reading `work-context.md`, provide a comprehensive summary to confirm full understanding:

   - **Task Overview**: What we were working on and why
   - **Technical Context**: Key technical decisions, patterns, and conventions
   - **Progress Status**: What was completed with specific details
   - **Remaining Work**: What remains to be done with clear next steps
   - **Important Notes**: Any gotchas, dependencies, or critical context
   - **Work Documents**: List all referenced documents and their purposes

   This summary ensures no knowledge gaps exist before resuming work.

5. **Prepare to continue**: Set up the todo list based on remaining tasks

6. **Migration handling** (if legacy file found):
   - Offer to migrate the context to vault for future use
   - If user agrees, save to vault and remove the old file

## Implementation Details

- Use `mcp__vault__vault_get` with key `work-context` and branch scope
- For legacy support:
  - Use `git rev-parse --show-toplevel` to find repository root (if applicable)
  - Check for `work-context.md` in `.claude/context/` directory
  - Use standard file operations to read the context
- Migration process:
  - Save content to vault using `mcp__vault__vault_set` with branch scope
  - Remove old file with user permission

This helps ensure a smooth continuation of work even after a break or terminal closure.

Would you like me to resume the previous work session?