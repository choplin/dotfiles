---
allowed-tools: mcp__amux__*, Bash(git *), Read, LS, TodoWrite
description: Resume work from previously saved context
---

# Resume Workspace

This command resumes work from a previously suspended workspace session.

## Search Location

The `work-context.md` file will be searched in the following priority order:

1. **AMUX workspace storage** (if running under AMUX management)
2. **Git repository root** (if in a git repository)
3. **Current directory** (as fallback)

## Process

I will:

1. **Check for saved context**:

   - **AMUX**: Use `mcp__amux__workspace_storage_list`
   - **Non-AMUX**: Check git repository root or current directory for `work-context.md`

2. **Load the context**:

   - **AMUX**: Use `mcp__amux__workspace_storage_read`
   - **Non-AMUX**: Use file read operations

3. **Display workspace information**:

   - **AMUX**: Use `mcp__amux__resource_workspace_show`
   - **Non-AMUX**: Use git commands (`git status`, `git branch`) and `pwd`

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

- First attempt to use AMUX MCP tools if available
- For non-AMUX environments:
  - Use `git rev-parse --show-toplevel` to find repository root
  - Check for `work-context.md` in repository root, then current directory
  - Use standard file operations to read the context

This helps ensure a smooth continuation of work even after a break or terminal closure.

Would you like me to resume the previous work session?
