#!/bin/bash

# Branch setup automation script
# This script automates the Git Workflow for worktree creation:
# - Creates worktree with naming convention: {repo_name}-{branch_name}
# - Creates CLAUDE.md at worktree root that imports original with @{original_tree}/CLAUDE.md
# - Creates symlinks from original tree for all gitignored items:
#   * CLAUDE.md files in subdirectories (not root)
#   * .claude/ directory
#
# Usage: ./setup-worktree.sh <branch-name>

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <branch-name>"
    exit 1
fi

BRANCH_NAME="$1"
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
WORKTREE_NAME="${REPO_NAME}-${BRANCH_NAME}"
ORIGINAL_REPO=$(git rev-parse --show-toplevel)
WORKTREE_PATH="${ORIGINAL_REPO}/.worktrees/${WORKTREE_NAME}"

echo "Setting up worktree for branch: $BRANCH_NAME"
echo "Repository: $REPO_NAME"
echo "Worktree path: $WORKTREE_PATH"

# 1. Create branch and worktree
echo "Creating branch and worktree..."
git checkout -b "$BRANCH_NAME"
git checkout main
git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"

# 2. Create worktree CLAUDE.md
echo "Creating worktree CLAUDE.md..."
cd "$WORKTREE_PATH"
cat > CLAUDE.md << EOF
@${ORIGINAL_REPO}/CLAUDE.md

# Worktree-specific instructions for ${BRANCH_NAME} branch

EOF

# 3. Create symlinks
echo "Creating symlinks..."

# Link .claude directory
if [ -d "${ORIGINAL_REPO}/.claude" ]; then
    ln -s ../../.claude .claude
    echo "Created symlink to .claude directory"
fi

# Create subdirectory CLAUDE.md symlinks
cd "$ORIGINAL_REPO"
fd -t f "CLAUDE.md" --exclude ".worktrees" --exclude "./CLAUDE.md" | while read -r f; do
    cd "$WORKTREE_PATH"
    mkdir -p "$(dirname "$f")"
    ln -sf "../../$f" "$f"
    echo "Created symlink to $f"
    cd "$ORIGINAL_REPO"
done

# 4. Verify setup
echo "Verifying setup..."
cd "$WORKTREE_PATH"
echo "Git status:"
git status
echo ""
echo "CLAUDE.md symlinks:"
fd -t l "CLAUDE.md" | sort

echo ""
echo "Worktree setup complete!"
echo "To start working: cd $WORKTREE_PATH"
