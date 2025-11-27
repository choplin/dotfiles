---
allowed-tools: Read, LS, TodoRead, mcp__vault__vault_set
description: Save current work context for later resumption
---

# Suspend Workspace

This command saves the current work context for later resumption.

## Save Location

The work context will be saved to the vault MCP with key `work-context` in branch scope, making it accessible from any directory within the current repository or workspace while on the same branch.

## Process

I will save comprehensive context:

1. **Context & Background**: What we're working on and why

2. **Discussions & Decisions**: Key points discussed and decisions made
   - Include links to any discussion documents written during work
   - Reference decision documents, analysis, or rationale files created

3. **Completed Work**: What has been done so far with specific files and changes

4. **Remaining Tasks**: What still needs to be done

5. **Current State**:
   - Active files being edited
   - Any uncommitted changes
   - Environment setup details

6. **Work Documents**:
   - Links to any work-in-progress documentation
   - References to design documents, specs, or notes created during work
   - Paths to temporary files or drafts related to the task

## Implementation Details

- Save context to vault using `mcp__vault__vault_set` with:
  - Key: `work-context`
  - Scope: `"branch"` (string literal "branch", NOT the branch name)
  - Content: Markdown-formatted work context

**Example tool call**:

```
mcp__vault__vault_set(
  key: "work-context",
  scope: "branch",    // ← Must be the string "branch", NOT branch name
  content: "..."
)
```

**CRITICAL**: Use `scope: "branch"` (the string literal "branch"), NOT `branch: {current-branch-name}`. The `branch` parameter should be left as default (current branch is used automatically).

**IMPORTANT**: The work context must be comprehensive and self-contained. When resuming work later, reading only this context should provide ALL necessary information without any knowledge gaps. Include:

- All technical decisions and their rationale
- Code patterns and conventions discovered
- Dependencies and environment specifics
- Any gotchas or non-obvious aspects encountered
- Full context that allows seamless work continuation

Please confirm that you want to suspend the current work session.