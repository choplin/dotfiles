# Resume Workspace

This command resumes work from a previously suspended workspace session.

I will:

1. **Check for saved context**: Use `mcp__amux__workspace_storage_list` to check if `work-context.md` exists

2. **Load the context**: Use `mcp__amux__workspace_storage_read` to read the saved work context

3. **Display workspace information**: Show the current workspace details using `mcp__amux__resource_workspace_show`

4. **Summarize the context**: Provide a brief overview of:

   - What we were working on
   - What was completed
   - What remains to be done
   - Any important decisions or context

5. **Prepare to continue**: Set up the todo list based on remaining tasks

This helps ensure a smooth continuation of work even after a break or terminal closure.

Would you like me to resume the previous work session?
