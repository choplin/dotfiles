# Claude Commands Directory Structure

This directory contains custom slash commands organized by functionality.

## Directory Organization

### `claude/`

Claude-specific system commands

- `remind.md` - Reload global memory instructions from ~/.claude/CLAUDE.md

### `context/`

Working context management

- `resume.md` - Resume a previously suspended work session
- `suspend.md` - Save current work context for later resumption

### `project/`

Project planning and ideation

- `discuss.md` - Deep discussion mode for exploring ideas without implementation
- `name-project.md` - Find optimal project names with conflict checking
- `quick-chat.md` - Quick, focused discussions with honest feedback
- `understand-idea.md` - Clarify ideas and requirements before implementation

### `review/`

Document review and improvement

- `critical-review.md` - Third-party critical analysis of documents
- `fact-check.md` - Verify technical documents contain only facts
- `revise-document.md` - Comprehensive document revision for clarity

### `workflow/`

Development workflow commands

- `rebase-onto-rewritten.md` - Rebase onto force-pushed branches

## Usage

Commands are invoked using their path relative to this directory:

- `/context/suspend` - Suspend current work
- `/review/fact-check` - Fact-check a document
- `/project/quick-chat` - Start a quick discussion

## Command Naming Conventions

- Directory names serve as natural prefixes (e.g., `context/resume` instead of `workspace-resume`)
- Commands use descriptive verb-noun combinations
- Related commands are grouped in the same directory
