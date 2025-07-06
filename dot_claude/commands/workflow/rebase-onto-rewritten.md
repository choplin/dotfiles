---
allowed-tools: Bash(git *)
description: Help rebase onto a base branch with rewritten history
---

# Rebase onto Rewritten History

This command helps rebase your current branch onto a base branch that has rewritten its history (e.g., through squash-and-merge or force-push).

**Usage**: Provide:

1. The first (oldest) commit to cherry-pick from your branch (required)
2. The base branch to rebase onto (optional, default: main)

I will:

1. **Analyze the situation**:

   - Show current branch commits to help you identify the first commit
   - Show base branch recent history
   - Prepare to cherry-pick from the specified commit to HEAD

2. **Create a backup**:

   - Create a backup branch (e.g., `<branch>-backup-<timestamp>`)

3. **Prepare for rebase**:

   - Create a temporary branch from the latest base branch
   - Use the range from your specified commit to HEAD

4. **Cherry-pick commits**:

   - Apply all commits from the specified commit to HEAD
   - If conflicts arise, I'll stop and show you the conflicting files
   - Wait for your instructions on how to resolve conflicts
   - Show progress during the process

5. **Finalize**:
   - Rename branches to preserve the original branch name
   - Delete temporary branch
   - Show final status

This process ensures your work is safely rebased even when the base branch history has been rewritten.

Please provide:

- First commit SHA to cherry-pick (I'll show you the commit history to help):
- Base branch name (optional, default: main):
