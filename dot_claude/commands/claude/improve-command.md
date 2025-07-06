---
allowed-tools: Read, Write, Edit, MultiEdit, Glob, LS
description: Improve and update the previously executed slash command
---

# Improve Command

Review the results of the previously executed slash command, identify areas for improvement, and update it to be more effective.

## Command File Search

The target command file is searched using the following methods:

1. **Traverse upward from current directory**:

   - Check for `.claude/commands/` existence in each directory
   - If `.claude/commands/` is found, search for the target command within it
   - **If the command is not found, continue traversing upward**
   - Eventually reach `~/.claude/commands/`

2. **Identify file from command name**:
   - Find the `.md` file corresponding to the command name (e.g., `/suspend` → `suspend.md`)
   - Include category subdirectories (claude/, context/, project/, review/, workflow/) in the search

This method prioritizes repository-local commands while falling back to global commands when not found locally.

**Usage**: Tell me about the previously executed command name and its results. I will analyze from the following perspectives and propose improvements.

## Analysis Framework

1. **Execution Result Evaluation**

   - Did it achieve the expected results?
   - Were there any unexpected behaviors or outcomes?
   - Performance or efficiency issues

2. **Intent Alignment**

   - Did it accurately understand the user's original intent?
   - Were there any misinterpretations of instructions?
   - Was any necessary context information missing?

3. **Command Instruction Clarity**

   - Ambiguous expressions or unclear instructions
   - Insufficient specification of prerequisites or constraints
   - Unclear output format or quality standards

4. **Improvement Suggestions**

   - Specific wording modifications
   - Additional instructions or examples to add
   - Structure or format improvements
   - Edge case handling

5. **Implementation**
   - Update the improved command file
   - Clear explanation of changes
   - Important notes for future usage

Please share the previously executed command and its results:
