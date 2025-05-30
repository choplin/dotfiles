#!/bin/bash

# Newline enforcement script
# Ensures all text files in the repository end with a newline
# Follows the File Formatting rule: "ALWAYS add newline at end of all text files"
#
# Usage: ./fix-newlines.sh [directory]
# If no directory specified, uses current directory

set -e

TARGET_DIR="${1:-.}"

echo "Fixing newlines in: $TARGET_DIR"

# Find all text files (excluding binary files, .git, node_modules, etc.)
fd -t f -E ".git" -E "node_modules" -E ".worktrees" -E "*.png" -E "*.jpg" -E "*.jpeg" -E "*.gif" -E "*.ico" -E "*.pdf" -E "*.zip" -E "*.tar.gz" -E "*.exe" -E "*.dll" -E "*.so" . "$TARGET_DIR" | while read -r file; do
    # Check if file ends with newline
    if [[ -s "$file" ]] && [[ $(tail -c1 "$file" | wc -l) -eq 0 ]]; then
        echo "Adding newline to: $file"
        echo "" >> "$file"
    fi
done

echo "Newline enforcement complete!"
