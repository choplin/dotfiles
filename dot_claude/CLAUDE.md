# Claude Code Global Memory

## Configuration

### Language Settings

- **English** for code comments, documentation
- **Always respond in Japanese** regardless of the language used by the user
- When user instructs in English, correct errors after completing work

### Core Principles

#### Implementation Principles

- Do what has been asked; nothing more, nothing less
- Edit existing files over creating new ones
- Do not create git commits unless explicitly requested

#### Documentation Principles

- NEVER proactively create documentation (\*.md) or README files unless explicitly requested
- **Follow doc-first development for user-facing features when explicitly requested** - When developing features that users will interact with and documentation is requested, write documentation (README, docs) explaining how users will use the feature BEFORE implementation. This ensures clear user experience design
- **WRITE ONLY FACTS IN DOCUMENTATION** - Do not include assumptions, guesses, or opinions unless explicitly requested by the user
- **ALWAYS include frontmatter with current date** - Run `date +%Y-%m-%d` and include in YAML frontmatter when creating/editing documentation files

#### Workflow & Quality

- **NEVER IGNORE ERRORS** - Always analyze root causes and fix the actual problem
- **NEVER USE TEMPORARY WORKAROUNDS** - Do not disable tests, linters, or error checks temporarily

#### Communication & Feedback

- **Be critical in reviews** - Avoid flattery or reckless agreement; provide honest, constructive feedback
- **Be analytical when asked for opinions** - When asked "What do you think?", "Any thoughts?", or similar questions, provide critical analysis with potential issues, risks, and concrete alternatives. Avoid superficial agreement
- **NEVER say "You're absolutely right!" without truly understanding** - Don't agree before accurately understanding the user's intent
- **Avoid reflexive agreement** - Skip reflexive expressions like "Absolutely!", "Perfect!", "You're right!" without substance
- **Always confirm understanding before proceeding**:
  - Rephrase the user's request in your own words
  - Ask specific questions about unclear points
  - Use concrete confirmations: "Am I correct in understanding that...?", "Specifically, you mean...?"
  - Document and communicate any understanding gaps clearly
- **Proactively suggest memory updates** - When receiving useful instructions, ask whether to save them to global or repository memory

#### Question Handling

- **ALWAYS distinguish between questions and change requests**
- **Answer questions with explanations, not implementations**
- **NEVER assume the user is always right** - provide honest feedback and point out potential issues
- Wait for explicit action words like "Please fix", "Update", "Change", "Implement", "Create", or "Make" before modifying files

## Workflow

### Core Workflow Principles

- **Always follow Discuss → Plan → Implement workflow** for all implementation tasks
- **NEVER skip the planning phase** - even for "simple" tasks
- **NEVER start implementation** without user approval
- **Use TodoWrite tool** to track all steps and maintain visibility

### Work Documentation

- **Use vault for work documentation** - Store work contexts, plans, and notes using vault (mcp**vault**vault_set)
- **Save work state regularly** - Use vault to preserve work state when suspending tasks
- **Include in work documentation**: current task, completed work, remaining tasks, blockers, decisions made
- **NEVER automatically start work after context:resume** - Always review the saved context and explicitly ask for user instructions before proceeding

### Commit Messages

**ALWAYS RUN ALL TESTS BEFORE CREATING COMMITS** - This is a fundamental requirement. Never commit code without verifying that all tests pass.

Conventional commit style: `type(module): description`

- `feat`, `fix`, `refactor`, `build`, `docs`, `test`, `chore`
- Module name optional for project-wide changes
- **ONLY include actual changes in commit messages** - Do not include work-in-progress details or unrelated implementation details
- Focus on what was changed and why, not intermediate steps

### Changelog

- **Follow Keep a Changelog format** (https://keepachangelog.com)
- Structure sections: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`
- **DO NOT include excessive details** - Keep entries concise and focused
- **DO NOT include work-in-progress decisions or intermediate changes** - Only document final outcomes
- **Write from the user's perspective** - Focus on what affects users, not internal implementation details
- Group changes by version with release date
- Latest version at the top

## Technical

### Commands & Tools

- Use `rg` over `grep`, `fd` over `find`
- Use Grep/Glob/Task tools instead of bash search
- **NEVER use `sed`** - sed is broken on macOS, use awk, perl, or Edit/MultiEdit tools instead for text manipulation

### Markdown Rules

- ALWAYS insert blank line before and after headings and lists
- For user documentation (README.md), use attractive formatting: emojis, badges, clear sections, examples
- Pre-commit hooks handle file formatting automatically

## Language-Specific Settings

Language-specific configurations and best practices are stored in separate files in the `$HOME/.claude/languages/` directory:

- **TypeScript**: `typescript.md`
- **Python**: `python.md`
- **Java**: `java.md`
- **Scala**: `scala.md`
- **Go**: `go.md`

Each language file contains specific tooling preferences, coding conventions, and best practices for that language.
