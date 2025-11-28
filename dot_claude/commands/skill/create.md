---
allowed-tools: Read, Write, Glob, Bash, AskUserQuestion
description: Create a new skill with proper structure
---

# Create New Skill

Create a new skill for Claude Code with proper SKILL.md structure and documentation.

## Usage

Provide the skill name and its purpose. I will:

1. **Create skill directory** at `~/.claude/skills/{skill-name}/`

2. **Generate SKILL.md** with:
   - YAML frontmatter (name, description)
   - Clear instructions for Claude
   - Trigger conditions and usage examples
   - Tool restrictions (if needed)

3. **Create supporting files** (optional):
   - Scripts
   - Templates
   - Reference files

## What Skills Are

Skills are modular capabilities that extend Claude's functionality. They are **model-invoked**—Claude automatically decides when to use them based on the description in the SKILL.md file.

## Key Components

### Required: SKILL.md

Every skill needs a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: your-skill-name
description: What it does and when to use it
---
```

The **description** field is critical—it should explain:
- What the skill does
- When Claude should use it
- What triggers this skill

### Optional: Tool Restrictions

You can limit which tools the skill can use:

```yaml
allowed-tools: Read, Grep, Glob
```

### Optional: Supporting Files

- Scripts (`.sh`, `.py`, etc.)
- Templates (`.template`, `.txt`, etc.)
- Reference files (`.md`, `.json`, etc.)

## What to Provide

1. **Skill name**: Short, descriptive name (e.g., `code-reviewer`, `api-generator`)
2. **Purpose**: What problem does it solve?
3. **Trigger conditions**: When should Claude use this skill?
4. **Tool restrictions** (optional): Limit to specific tools?

## Examples

- "Create a skill for reviewing API designs" → `api-design-reviewer`
- "Create a skill for generating test data" → `test-data-generator`
- "Create a skill for analyzing performance" → `performance-analyzer`

## Process

I will:
1. Ask for skill details if not provided
2. Generate SKILL.md content
3. Show you the content for review
4. Create the skill directory and file after your approval
5. Suggest next steps (e.g., use `/skill:edit` to refine)

Let's create your skill! What would you like the skill to do?
