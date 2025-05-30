#!/bin/bash

# Trailing whitespace removal script
# Removes all trailing whitespace from text files in the repository
# Follows the File Formatting rule: "DO NOT allow trailing white spacing in each line"
#
# Usage: ./fix-trailing-whitespace.sh [directory]
# If no directory specified, uses current directory

set -e

TARGET_DIR="${1:-.}"

echo "Removing trailing whitespace in: $TARGET_DIR"

# Find all text files (excluding binary files, .git, node_modules, etc.)
fd -t f -E ".git" -E "node_modules" -E ".worktrees" -E "*.png" -E "*.jpg" -E "*.jpeg" -E "*.gif" -E "*.ico" -E "*.pdf" -E "*.zip" -E "*.tar.gz" -E "*.exe" -E "*.dll" -E "*.so" . "$TARGET_DIR" | while read -r file; do
    # Check if file has trailing whitespace
    if grep -q '[[:space:]]$' "$file" 2>/dev/null; then
        echo "Removing trailing whitespace from: $file"
        # Use sed to remove trailing whitespace from each line
        sed -i '' 's/[[:space:]]*$//' "$file"
    fi
done

echo "Trailing whitespace removal complete!"