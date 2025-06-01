#!/bin/bash

# PR checkout and worktree setup script
# This script fetches a GitHub PR and creates a worktree for it
# while ensuring the original branch is restored regardless of success/failure
#
# Usage: ./pr-checkout.sh <pr-number>

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <pr-number>"
    exit 1
fi

PR_NUMBER="$1"
ORIGINAL_REPO=$(git rev-parse --show-toplevel)
ORIGINAL_BRANCH=$(git branch --show-current)

echo "Checking out PR #$PR_NUMBER"
echo "Current branch: $ORIGINAL_BRANCH"

# Function to restore original branch
restore_original_branch() {
    echo "Restoring original branch: $ORIGINAL_BRANCH"
    git checkout "$ORIGINAL_BRANCH" 2>/dev/null || {
        echo "Warning: Could not restore original branch"
    }
}

# Set trap to ensure we always return to original branch
trap restore_original_branch EXIT

# 1. Fetch PR branch
echo "Fetching PR branch..."
gh pr checkout "$PR_NUMBER"

# Get the checked out branch name
PR_BRANCH=$(git branch --show-current)
echo "PR branch: $PR_BRANCH"

# 2. Check if worktree already exists
WORKTREE_PATH="${ORIGINAL_REPO}/.worktrees/${PR_BRANCH}"
if [ -d "$WORKTREE_PATH" ]; then
    echo "Warning: Worktree already exists at $WORKTREE_PATH"
    read -p "Remove existing worktree and recreate? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git worktree remove "$WORKTREE_PATH" --force
    else
        echo "Aborting worktree creation"
        exit 1
    fi
fi

# 3. Create worktree using existing script
echo "Creating worktree for PR branch..."
"$HOME/.claude/scripts/setup-worktree.sh" "$PR_BRANCH"

echo ""
echo "PR checkout complete!"
echo "PR #$PR_NUMBER checked out to: $WORKTREE_PATH"
echo "Original branch restored: $ORIGINAL_BRANCH"
