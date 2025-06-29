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
- **ALWAYS run `date` command before describing current date or time** - Ensure accurate timestamps in documentation

#### Workflow & Quality

- **Always follow Discuss → Plan → Implement workflow** (see detailed section below)
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
- Questions that require answers, NOT implementation:
  - "Do we need ~?" → Explain whether it's needed and why
  - "Is it correct that ~?" → Confirm or correct the understanding
  - "What does ~ do?" → Explain the functionality
  - "How does ~ work?" → Provide explanation of the mechanism
  - "Why is ~ used?" → Explain the reasoning
  - "Should we ~?" → Provide recommendation with rationale
  - "Can you explain ~?" → Give detailed explanation
- **DO NOT automatically start implementing changes** when asked questions
- **NEVER assume the user is always right** - provide honest feedback and point out potential issues
- Wait for explicit action words like "Please fix", "Update", "Change", "Implement", "Create", or "Make" before modifying files
- Default to answering questions with explanations rather than jumping to implementation

## Workflow

### AMUX (Agent Multiplexer) Overview

**AMUX** is the primary tool for workspace management. It provides isolated git worktree-based environments for each task/branch.

#### Workspace Management via MCP:

- **Create workspace**: Use `mcp__amux__workspace_create` with branch name
- **List workspaces**: Use `mcp__amux__workspace_list`
- **Show workspace**: Use `mcp__amux__resource_workspace_show`
- **Remove workspace**: Use `mcp__amux__workspace_remove`
- **Workspace operations are primarily handled through MCP tools, not CLI commands**

#### Context Management:

- Use `work-context.md` to save work state when suspending tasks
- **Write context**: `mcp__amux__workspace_storage_write`
- **Read context**: `mcp__amux__workspace_storage_read`
- **List storage**: `mcp__amux__workspace_storage_list`
- Include: branch info, completed work, remaining tasks, current state

### Standard Process

1. **Understand the requirements**
2. **Plan the implementation**
3. **Create AMUX workspace** (use `mcp__amux__workspace_create` with branch name)
4. **Document context and plan** using `work-context.md` in AMUX workspace storage
5. **Begin implementation** in the new workspace

### Discuss → Plan → Implement Workflow

This is a critical workflow that must be followed for all implementation tasks.

**AMUX Usage**: All implementation work should be done in isolated AMUX workspaces. Use AMUX to create, manage, and switch between workspaces for different tasks/branches.

#### 1. Discuss Phase (要件確認)

- **Understand the request**: Confirm your understanding of what the user is asking for
- **Clarify ambiguities**: Ask questions if requirements are unclear
- **Identify scope**: Determine the impact and boundaries of the change
- **Check prerequisites**: Verify any assumptions or dependencies

#### 2. Plan Phase (計画提示)

- **Create detailed task list** using TodoWrite tool with:
  - Step-by-step implementation approach
  - Files that will be modified or created
  - Potential risks or considerations
  - Testing approach
- **Present the plan** to the user with clear structure
- **Explicitly request approval**: Always end with 「この計画で進めてよろしいですか？」or similar
- **WAIT for user confirmation** before proceeding to implementation
- **Prepare AMUX workspace**: After approval, create workspace with `mcp__amux__workspace_create`

#### 3. Implement Phase (実装)

- **Only start after explicit approval** from the user
- **Work in AMUX workspace**: All implementation must be done in the created AMUX workspace
- **Save context regularly**: Use `mcp__amux__workspace_storage_write` to save `work-context.md` when suspending work
- **Update task status** in TodoWrite:
  - Mark tasks as `in_progress` when starting
  - Mark as `completed` immediately upon completion
- **Follow the approved plan** without deviation
- **Report any blockers** if the plan needs adjustment

#### Important Notes

- **NEVER skip the planning phase** - even for "simple" tasks
- **NEVER start implementation** without user approval
- **This workflow applies to ALL coding tasks**, regardless of complexity
- **Use TodoWrite tool** to track all steps and maintain visibility
- **ALWAYS use AMUX workspaces** for implementation work to maintain clean separation of tasks
- **Document work context** in `work-context.md` for seamless task suspension/resumption

### Commit Messages

**ALWAYS RUN ALL TESTS BEFORE CREATING COMMITS** - This is a fundamental requirement. Never commit code without verifying that all tests pass.

Conventional commit style: `type(module): description`

- `feat`, `fix`, `refactor`, `build`, `docs`, `test`, `chore`
- Module name optional for project-wide changes

## Technical

### Commands & Tools

- Use `rg` over `grep`, `fd` over `find`
- Use Grep/Glob/Task tools instead of bash search
- Pre-commit hooks handle file formatting
- **NEVER use `sed`** - sed is broken on macOS, use awk, perl, or Edit/MultiEdit tools instead for text manipulation

### Library Selection

- Check functionality, maintenance status, and adoption rate
- Verify active development, recent updates, and community size

### Markdown Rules

- ALWAYS insert blank line before and after headings and lists
- For user documentation (README.md), use attractive formatting: emojis, badges, clear sections, examples

## Language-Specific Settings

### TypeScript

- Use `pnpm` as preferred package manager (over npm/yarn)
- Use `Bun` for CLI tool development
- Use `Vite` as bundler
- Use `Biome` for linting and formatting (over ESLint + Prettier)
- Configure strict TypeScript settings in `tsconfig.json`
- Prefer TypeScript over JavaScript
- **NEVER use `any`** - use proper type definitions
- Prefer named exports over default exports
- Follow conventional project structure: `src/`, `tests/`, `dist/`

### Python

- Use `uv` for package management and virtual environments
- Use `ruff` for linting and formatting
- Use `pytest` for testing
- Always use type hints with proper annotations
- Follow PEP 8 style guide
- Use `pyproject.toml` for project configuration
- Follow conventional project structure: `src/`, `tests/`, `docs/`

### Java

- Use `Gradle` for build management
- Use `JUnit 5` for testing
- Use `Spotless` for code formatting with Google Java Format compatible rules
- Follow Google Java Style Guide
- Use proper package structure: `com.company.project`
- Prefer modern Java features (records, switch expressions, etc.)
- Use `var` for local variable type inference when appropriate

### Scala

- Use `sbt` or `mill` for build management
- Use `ScalaTest` or `munit` for testing
- Use `Scalafmt` for code formatting
- Use `scalafix` and `wartremover` for linting
- Follow Scala Style Guide
- Prefer immutable data structures
- Use for-comprehensions over nested maps/flatMaps
- Leverage type system and avoid runtime exceptions

### Go

#### Package Management & Tooling
- Use `go mod` for dependency management
- Use Go 1.24's `go tool` for installing and running development tools
- Use `gofumpts` for code formatting (stricter than gofmt)
- Use `golangci-lint` for comprehensive linting
- Use `go test` with table-driven tests
- Use `testify` for test assertions when needed

#### Error Handling
- **NEVER use panic** unless explicitly requested by user
- Define custom error types instead of using `fmt.Errorf`
- Use `errors.As()` and `errors.Is()` for error checking
- Always return errors instead of panicking
- Wrap errors with context when propagating

#### Code Style & Conventions
- Follow Effective Go and Go Code Review Comments
- Naming conventions:
  - Use MixedCaps or mixedCaps, not underscores
  - Acronyms should be all caps (URL, HTTP, ID)
  - Interface names should end with `-er` suffix when appropriate
- Keep interfaces small and focused
- Prefer composition over inheritance

#### Project Structure
- Use standard Go project layout:
  - `/cmd` for main applications
  - `/internal` for private application code
  - `/pkg` for public libraries (optional, use sparingly)
  - Keep `go.mod` at repository root
- One package per directory
- Package names should be lowercase, single-word

#### Best Practices
- Use goroutines and channels idiomatically
- Avoid goroutine leaks with proper cancellation
- Benchmark performance-critical code
- Write idiomatic Go code, not translations from other languages
