---
allowed-tools: Bash(git *), Read, LS, TodoRead, mcp__vault__vault_set
description: Save current work context for later resumption
---

# Suspend Workspace

This command saves the current work context for later resumption.

## Save Location

The work context will be saved to the vault MCP with key `work-context` in branch scope, making it accessible from any directory within the current repository or workspace while on the same branch.

## Process

I will gather workspace information and save comprehensive context:

1. **Workspace Information**:
   - Branch name (if in git repository)
   - Directory path
   - Repository details

2. **Context & Background**: What we're working on and why

3. **Discussions & Decisions**: Key points discussed and decisions made
   - Include links to any discussion documents written during work
   - Reference decision documents, analysis, or rationale files created

4. **Completed Work**: What has been done so far with specific files and changes

5. **Remaining Tasks**: What still needs to be done

6. **Current State**:
   - Active files being edited
   - Any uncommitted changes
   - Environment setup details

7. **Work Documents**:
   - Links to any work-in-progress documentation
   - References to design documents, specs, or notes created during work
   - Paths to temporary files or drafts related to the task

## Implementation Details

- Use `git rev-parse --show-toplevel` to find repository root (if in git repo) for workspace information
- Save context to vault using `mcp__vault__vault_set` with:
  - Key: `work-context`
  - Branch: Current branch (branch scope)
  - Content: Markdown-formatted work context

**IMPORTANT**: The work context must be comprehensive and self-contained. When resuming work later, reading only this context should provide ALL necessary information without any knowledge gaps. Include:

- All technical decisions and their rationale
- Code patterns and conventions discovered
- Dependencies and environment specifics
- Any gotchas or non-obvious aspects encountered
- Full context that allows seamless work continuation

Please confirm that you want to suspend the current work session.