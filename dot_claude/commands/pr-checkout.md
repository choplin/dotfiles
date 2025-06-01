# Checkout PR and Create Worktree

This command fetches a GitHub PR branch and creates a worktree for it.

**Usage**: Provide the PR number (e.g., "123")

I will use the pr-checkout.sh script to:

1. Save current branch and ensure restoration even if errors occur
2. Fetch the PR branch using `gh pr checkout <pr-number>`
3. Check for existing worktree conflicts and handle them
4. Create a worktree using setup-worktree.sh script
5. Return to the original branch

Please provide the PR number you want to checkout:
