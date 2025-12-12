---
allowed-tools: Bash(rm), Read, LS, TodoWrite, mcp__vault__vault_get, mcp__vault__vault_list
description: Resume work from previously saved context
---

# Resume Workspace

This command resumes work from a previously suspended workspace session.

## Context Location

The work context will be retrieved from:

1. **Primary**: vault MCP with key `work-context` (branch scope)

## Process

I will:

1. **Check for saved context**:
   - First, try to retrieve from vault using `mcp__vault__vault_get` with key `work-context`

2. **Load the context**:
   - If found in vault, use the retrieved content directly

3. **Display basic workspace information**

4. **Summarize understanding**: After reading `work-context.md`, provide a comprehensive summary to confirm full understanding:
   - **Task Overview**: What we were working on and why
   - **Technical Context**: Key technical decisions, patterns, and conventions
   - **Progress Status**: What was completed with specific details
   - **Remaining Work**: What remains to be done with clear next steps
   - **Important Notes**: Any gotchas, dependencies, or critical context
   - **Work Documents**: List all referenced documents and their purposes

   This summary ensures no knowledge gaps exist before resuming work.

5. **Prepare to continue**: Set up the todo list based on remaining tasks

## Implementation Details

- Use `mcp__vault__vault_get` with:
  - Key: `work-context`
  - Scope: `"branch"` (string literal "branch", NOT the branch name)

**Example tool call**:

```
mcp__vault__vault_get(
  key: "work-context",
  scope: "branch"    // ← Must be the string "branch", NOT branch name
)
```

**CRITICAL**: Use `scope: "branch"` (the string literal "branch"), NOT `branch: {current-branch-name}`. The `branch` parameter should be left as default (current branch is used automatically).

- Migration process:
  - Save content to vault using `mcp__vault__vault_set` with `scope: "branch"`
  - Remove old file with user permission

This helps ensure a smooth continuation of work even after a break or terminal closure.

Would you like me to resume the previous work session?
