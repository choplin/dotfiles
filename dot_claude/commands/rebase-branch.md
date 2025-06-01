# Rebase Branch from Main (Post Squash-and-Merge)

This command recreates a branch from main and cherry-picks commits, solving the squash-and-merge rebase issue.

**Usage**: Provide the existing branch name that needs to be rebased from main.

I will:

1. Show commit history of the branch to help you identify commits to cherry-pick
2. Ask you to specify the commit range for cherry-picking
3. Use rebase-branch.sh script to handle the complex worktree and branch operations
4. Handle any cherry-pick conflicts interactively if they occur

Please provide the branch name you want to rebase from main:
