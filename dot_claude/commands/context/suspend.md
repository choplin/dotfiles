# Suspend Workspace

This command saves the current work context to the AMUX workspace storage for later resumption.

I will use `mcp__amux__resource_workspace_show` to get workspace information and document:

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

The context will be saved to `work-context.md` in the AMUX workspace storage using `mcp__amux__workspace_storage_write`.

**IMPORTANT**: The `work-context.md` must be comprehensive and self-contained. When resuming work later, reading only this file should provide ALL necessary context without any knowledge gaps. Include:

- All technical decisions and their rationale
- Code patterns and conventions discovered
- Dependencies and environment specifics
- Any gotchas or non-obvious aspects encountered
- Full context that allows seamless work continuation

Please confirm that you want to suspend the current work session.
