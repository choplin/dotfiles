---
allowed-tools: Read, Write, Edit, Glob, Bash, AskUserQuestion
description: Edit an existing skill
---

# Edit Skill

Edit an existing skill's SKILL.md file.

## Usage

### Without arguments

```
/skill:edit
```

Shows a list of all available skills in `~/.claude/skills/`.

### With skill name

```
/skill:edit <skill-name>
```

Edits the specified skill.

## Process

1. **List skills** (if no argument provided):
   - Scan `~/.claude/skills/` directory
   - Display skill names with their descriptions
   - Ask which skill to edit

2. **Load skill content**:
   - Read the current SKILL.md file
   - Display the current content

3. **Edit options**:
   - **Full rewrite**: Replace entire content
   - **Partial edit**: Edit specific sections
   - **Add content**: Append new sections

4. **Review and confirm**:
   - Show the new content
   - Ask for confirmation

5. **Save changes**:
   - Update the SKILL.md file
   - Confirm successful update

## What You Can Edit

- **Description**: Change when Claude should use this skill
- **Instructions**: Modify what the skill does
- **Tool restrictions**: Update `allowed-tools` list
- **Supporting content**: Add examples, references, etc.

## Examples

```
/skill:edit code-reviewer
```

Edits the `code-reviewer` skill.

```
/skill:edit
```

Lists all skills and asks which one to edit.

## Notes

- Changes take effect after restarting Claude Code
- The skill directory structure is preserved
- Original content is replaced (no versioning)
- Make sure to test your changes after editing

Let's edit your skill! Which skill would you like to modify?

## Implementation

Check if $ARGUMENTS is provided:

- **If $ARGUMENTS is empty**: List all skills
- **If $ARGUMENTS has a skill name**: Edit that skill

### Listing Skills

```bash
# Find all SKILL.md files
find ~/.claude/skills -name "SKILL.md" -type f
```

For each skill:
1. Extract skill name from directory
2. Extract description from YAML frontmatter
3. Display in a readable format

### Editing a Skill

1. Verify skill exists: `~/.claude/skills/$ARGUMENTS/SKILL.md`
2. Read the current content
3. Display current content to user
4. Ask for edit type (full/partial/add)
5. Collect new content
6. Show diff or new content for review
7. Save after confirmation
