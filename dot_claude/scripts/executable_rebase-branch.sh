#!/bin/bash

# Rebase branch from main script
# This script recreates a branch from main and handles worktree management
# Cherry-picking is done interactively in the command
#
# Usage: ./rebase-branch.sh <original-branch> <commit-range>

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <original-branch> <commit-range>"
    exit 1
fi

ORIGINAL_BRANCH="$1"
COMMIT_RANGE="$2"
TIMESTAMP=$(date +%s)
TEMP_BRANCH="temp-rebase-${TIMESTAMP}"
ORIGINAL_REPO=$(git rev-parse --show-toplevel)
WORKTREE_PATH="${ORIGINAL_REPO}/.worktrees/${ORIGINAL_BRANCH}"
TEMP_CLAUDE_MD="/tmp/claude-md-backup-${TIMESTAMP}.md"

echo "Rebasing branch: $ORIGINAL_BRANCH"
echo "Commit range: $COMMIT_RANGE"
echo "Temporary branch: $TEMP_BRANCH"

# 1. Save worktree CLAUDE.md if exists
echo "Saving worktree-specific knowledge..."
if [ -f "${WORKTREE_PATH}/CLAUDE.md" ]; then
    cp "${WORKTREE_PATH}/CLAUDE.md" "$TEMP_CLAUDE_MD"
    echo "Saved CLAUDE.md to temporary location"
else
    echo "No worktree CLAUDE.md found"
fi

# 2. Create temporary branch from main
echo "Creating temporary branch from main..."
git checkout main
git pull origin main
git checkout -b "$TEMP_BRANCH"

# 3. Cherry-pick commits (done by caller)
echo "Cherry-picking commits: $COMMIT_RANGE"
git cherry-pick $COMMIT_RANGE

# 4. Remove existing worktree and branch
echo "Removing existing worktree and branch..."
git worktree remove "$WORKTREE_PATH" --force
git branch -D "$ORIGINAL_BRANCH"

# 5. Rename temporary branch to original name
echo "Renaming branch..."
git branch -m "$TEMP_BRANCH" "$ORIGINAL_BRANCH"

# 6. Create new worktree
echo "Creating new worktree..."
"$HOME/.claude/scripts/setup-worktree.sh" "$ORIGINAL_BRANCH"

# 7. Restore worktree CLAUDE.md
if [ -f "$TEMP_CLAUDE_MD" ]; then
    echo "Restoring worktree-specific knowledge..."
    cp "$TEMP_CLAUDE_MD" "${WORKTREE_PATH}/CLAUDE.md"
    rm "$TEMP_CLAUDE_MD"
    echo "Restored CLAUDE.md to new worktree"
fi

echo ""
echo "Branch rebase complete!"
echo "New worktree location: $WORKTREE_PATH"