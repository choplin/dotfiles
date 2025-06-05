# Claude Code Global Memory

## Configuration

### Language Settings

- **English** for code comments, documentation
- **Japanese** for chat responses
- When user instructs in English, correct errors after completing work

### Core Principles

- Do what has been asked; nothing more, nothing less
- Edit existing files over creating new ones
- NEVER proactively create documentation (\*.md) or README files unless explicitly requested
- **Always propose a plan before starting work and wait for user confirmation**
- Follow doc-first development: README/docs → tests → implementation
- Do not create git commits unless explicitly requested
- **NEVER IGNORE ERRORS** - Always analyze root causes and fix the actual problem
- **NEVER USE TEMPORARY WORKAROUNDS** - Do not disable tests, linters, or error checks temporarily

## Workflow

### Standard Process

1. **Understand the requirements**
2. **Plan the implementation**
3. **Set up branch** (use `~/.claude/scripts/setup-worktree.sh <branch-name>`)
4. **Document context and plan** in worktree CLAUDE.md
5. **Begin implementation** in the new worktree

### Git & PR Workflow

- Use git worktree: `{repo_root}/.worktrees/{branch_name}/`
- For new CLAUDE.md in subdirectories: create in original tree, symlink in worktree
- Draft PR descriptions in `pr-description.md` at repository root
- Do not create actual PR unless explicitly requested

### Commit Messages

Conventional commit style: `type(module): description`

- `feat`, `fix`, `refactor`, `build`, `docs`, `test`, `chore`
- Module name optional for project-wide changes
- **DO NO INCLUDE Claude attribution**

## Technical

### Commands & Tools

- Use `rg` over `grep`, `fd` over `find`
- Use Grep/Glob/Task tools instead of bash search
- Pre-commit hooks handle file formatting

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

## Scripts

- `setup-worktree.sh <branch-name>` - set up branches
- `pr-checkout.sh <pr-number>` - checkout PR and create worktree
- `rebase-branch.sh <original-branch> <commit-range>` - rebase from main
- `notify.sh [message] [title]` - send desktop notifications
