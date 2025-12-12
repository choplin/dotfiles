---
allowed-tools: Read, Write, LS, Bash
description: Create a new custom slash command
---

# Create Custom Command

Create a new custom slash command with proper structure and documentation.

## Usage

Provide the command name and its purpose. I will:

1. **Check for available locations**:

   - If `.claude/commands/` exists in the current project, ask whether to create it locally or globally
   - If only global `~/.claude/commands/` is available, create it there

2. **Suggest an appropriate directory** based on the command type:

   - `/claude/` - Claude-specific utilities
   - `/context/` - Context management commands
   - `/project/` - Project-specific workflows
   - `/review/` - Review and analysis commands
   - `/workflow/` - General workflow commands

3. **Create a well-structured command file** with:
   - Clear documentation and usage examples
   - Proper markdown formatting
   - Established command conventions

## Examples

- "I want a command to format JSON data" → Creates `/workflow/format-json.md`
- "I need a command for generating test cases" → Creates `/project/generate-tests.md`
- "Create a command to summarize long documents" → Creates `/review/summarize-long.md`

## What to provide

1. **Command purpose**: What problem does it solve?
2. **Expected behavior**: What should the command do?
3. **Any specific requirements**: Special formatting, options, etc.

I'll help you create a command that integrates well with your workflow, either in your project's `.claude/commands/` directory or in the global `~/.claude/commands/` directory.
