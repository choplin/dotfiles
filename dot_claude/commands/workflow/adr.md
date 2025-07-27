---
allowed-tools: Bash(ls, mkdir, find), Read, Write, LS
description: Record Architecture Decision Records (ADR) for important decisions
---

# Architecture Decision Record (ADR)

This command records important technical decisions as Architecture Decision Records (ADR) in your project.

## Usage

When you run this command, you'll be prompted to provide the following information:

1. **Title**: Brief description of the decision
2. **Status**: Accepted or Rejected
3. **Context**: Background on why this decision was needed
4. **Decision**: Details of the actual decision made
5. **Discussion**: The deliberation process and key discussion points
6. **Consequences**: Expected outcomes or impacts of this decision
7. **Alternatives**: Other options that were considered (optional)
8. **References**: External links or internal code references (optional)

## Storage Location

ADRs are saved in the following priority order:

1. `docs/adr/` (recommended)
2. `.adr/`

If no directory exists, `docs/adr/` will be created.

## Process

### 1. Identify Project Root

First, identify the current project's root directory.

### 2. Check/Create ADR Directory

Check for the ADR storage directory and create if necessary.

### 3. Check Existing ADRs

Retrieve the latest number from existing ADR files to determine the next number.

### 4. Collect ADR Information

Gather necessary information from the user. Date is automatically retrieved using the `date` command.

### 5. Create ADR File

Create the ADR file following the standard format.

Filename format: `ADR-{number}-{slug}.md`

- Number: Follows existing ADR numbering format (defaults to 4-digit zero-padding: 0001, 0002)
- Slug: URL-safe string generated from the title

**Important**:

- This command is for creating new ADRs only. It will not overwrite existing ADR files
- User confirmation is required when the filename is determined
- Final confirmation is required before writing the file

## ADR Format

```markdown
---
created: { YYYY-MM-DD }
---

# ADR-{number}: {title}

## Status

{Accepted | Rejected}

## Context

{background explanation}

## Decision

{decision details}

## Discussion

{deliberation process and key points}

## Consequences

{expected outcomes or impacts}

## Alternatives

{other options considered}

## References

{external links or internal code references}
```

Let's begin creating an ADR.
