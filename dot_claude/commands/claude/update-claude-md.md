---
allowed-tools: Read, Write, Edit, MultiEdit, LS, Glob
description: Update CLAUDE.md with previous instructions
---

# Update CLAUDE.md

Update the project's CLAUDE.md file with instructions from previous conversations. This command searches for CLAUDE.md starting from the current directory and traversing upward, then adds or updates content based on previous instructions.

**Important**: This command will always present proposed changes for review and discussion before making any updates. User approval is required before modifying CLAUDE.md.

## CLAUDE.md Search Process

The command searches for CLAUDE.md using the following approach:

1. **Start from current directory**:
   - Check if `CLAUDE.md` exists in the current directory
   - If not found, move to parent directory
   - Continue traversing upward until root directory

2. **Priority order**:
   - Repository-local `CLAUDE.md` (project-specific)
   - Global `~/.claude/CLAUDE.md` (if no local file found)

## Update Process

When updating CLAUDE.md, follow these principles:

1. **Review before updating**:
   - First, read the current CLAUDE.md content
   - Identify the appropriate section for the new instruction
   - Present the proposed changes to the user for review
   - Discuss if clarification or adjustments are needed
   - **IMPORTANT: Always get explicit approval before making any changes**

2. **Identify appropriate section**:
   - Look for existing sections that match the instruction type
   - Common sections: Technical, Workflow, Language-Specific Settings, Core Principles
   - Create new sections if no suitable section exists

3. **Content integration**:
   - Add new instructions under appropriate headings
   - Avoid duplicating existing instructions
   - Maintain consistent formatting and structure
   - Preserve existing content unless explicitly replacing

4. **Formatting guidelines**:
   - Use proper markdown heading hierarchy
   - Include blank lines before and after headings
   - Use bullet points for lists
   - Keep instructions concise and actionable

## Required Information

Please provide:
1. **The instruction to add**: What specific guidance or configuration should be added?
2. **Context**: What prompted this instruction? (e.g., error encountered, workflow improvement)
3. **Section preference** (optional): Which section should this go under?

Example usage:
- "Add instruction to always use pnpm instead of npm"
- "Document the requirement to run tests before commits"
- "Add workflow for handling database migrations"

Please share the instruction you'd like to add to CLAUDE.md: