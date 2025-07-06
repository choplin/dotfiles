---
allowed-tools: mcp__amux__*, Bash(git *), Write, Read, LS, TodoRead
description: Save current work context for later resumption
---

# Suspend Workspace

This command saves the current work context for later resumption.

## Save Location

The `work-context.md` file will be saved in the following priority order:

1. **AMUX workspace storage** (if running under AMUX management)
2. **Git repository root** (if in a git repository)
3. **Current directory** (as fallback)

## Process

I will gather workspace information using available tools:

- Try AMUX MCP tools first (`mcp__amux__resource_workspace_show`)
- Fall back to git commands (`git status`, `git branch`, `git rev-parse --show-toplevel`)
- Use file system commands if needed (`pwd`, file operations)

1. **Workspace Information**:
   - Branch name
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

- **AMUX environment**: Use `mcp__amux__resource_workspace_show` and `mcp__amux__workspace_storage_write`
- **Non-AMUX environment**: Use git commands and file system operations
- The context will be saved to `work-context.md` in the determined location

**IMPORTANT**: The `work-context.md` must be comprehensive and self-contained. When resuming work later, reading only this file should provide ALL necessary context without any knowledge gaps. Include:

- All technical decisions and their rationale
- Code patterns and conventions discovered
- Dependencies and environment specifics
- Any gotchas or non-obvious aspects encountered
- Full context that allows seamless work continuation

Please confirm that you want to suspend the current work session.
