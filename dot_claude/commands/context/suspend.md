# Suspend Workspace

This command saves the current work context to the AMUX workspace storage for later resumption.

I will use `mcp__amux__resource_workspace_show` to get workspace information and document:

1. **Workspace Information**:
   - Branch name
   - Directory path
   - Repository details
2. **Context & Background**: What we're working on and why

3. **Discussions & Decisions**: Key points discussed and decisions made

4. **Completed Work**: What has been done so far with specific files and changes

5. **Remaining Tasks**: What still needs to be done

6. **Current State**:
   - Active files being edited
   - Any uncommitted changes
   - Environment setup details

The context will be saved to `work-context.md` in the AMUX workspace storage using `mcp__amux__workspace_storage_write`.

Please confirm that you want to suspend the current work session.
