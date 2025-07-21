---
date: 2025-07-21
title: Spec-Driven Development Workflow
---

# Spec-Driven Development Workflow

This document describes the complete workflow for spec-driven development using Claude's command system.

## Overview

The spec-driven development workflow guides you through creating comprehensive specifications before implementation, ensuring clear requirements, thoughtful design, and systematic execution.

## Workflow Phases

### 1. Initialization

```bash
/spec:init {feature-name}
```

Creates initial specification structure in vault with metadata tracking.
- Interprets brief project descriptions
- Presents interpretation for approval before proceeding

### 2. Requirements Definition

```bash
/spec:requirements {feature-name}
```

Generates requirements in EARS format (Event-driven Actionable Requirements Syntax):

- Requirements labeled as REQ-001, REQ-002, etc.
- Acceptance criteria labeled as AC-001.1, AC-001.2, etc.
- Includes normal behavior, error handling, and edge cases
- MECE (Mutually Exclusive, Collectively Exhaustive) coverage check
- Each requirement includes testable acceptance criteria

### 3. Technical Design

```bash
/spec:design {feature-name}
```

Creates comprehensive technical design including:

- Analysis of existing implementation for consistency
- Architecture overview aligned with current patterns
- Component interactions (prefer Markdown, use diagrams when necessary)
- Data models compatible with existing schemas
- API specifications
- Implementation approach with regression prevention
- Requirement traceability showing which components handle which requirements

### 4. Task Breakdown

```bash
/spec:tasks {feature-name}
```

Generates Work Breakdown Structure (WBS) with branch strategy:

- Determines optimal PR breakpoints for review
- Maximum 3 levels deep  
- Tasks sized as S/M/L (no time estimates)
- Each task includes both tests and implementation (t-wada TDD style)
- Requirements-task mapping with MECE coverage verification
- Tasks reference specific requirements and acceptance criteria
- Marks PR submission points in task list

### 5. Implementation

```bash
/spec:implement {feature-name}
```

Executes tasks one at a time:

1. Shows implementation plan for approval
2. Manages branches per task strategy
3. Implements using t-wada style TDD (Red-Green-Refactor)
4. Commits only after Refactor phase is complete
5. Updates task status and work log
6. Notifies when PR breakpoint reached
7. Analyzes and suggests steering updates if needed

Repeat until all tasks complete. Prompts for next action based on remaining tasks.

### 6. Completion

```bash
/spec:complete {feature-name}
```

Finalizes the feature:

- Verifies all requirements have tests
- Runs full test suite
- Checks code quality
- Updates CHANGELOG
- Updates documentation
- Saves design doc (if significant)
- Identifies any ADRs needed
- Compiles outstanding items

### 7. Decline (Optional)

```bash
/spec:decline {feature-name}
```

Abandons a specification at any stage:

- Documents reason for declining
- Preserves all work for future reference
- Records lessons learned
- Updates metadata with decline status

## Steering Documents

### Initialize Steering

```bash
/steering:init
```

Creates three foundational documents:

- **Product**: Vision, target users, core value
- **Technical**: Stack, architecture, key patterns
- **Structure**: Directory layout, naming conventions

### Update Steering

```bash
/steering:update
```

Updates steering documents when:

- New patterns emerge
- Architecture evolves
- Technical decisions change

## Data Storage

All specifications and steering documents are stored in Vault MCP:

```
steering/
  product      # Product vision and goals
  tech         # Technical decisions
  structure    # Project structure

specs/{feature}/
  metadata     # Approval states and status
  requirements # EARS-format requirements
  design       # Technical design document
  tasks        # WBS task breakdown
```

## Key Principles

1. **Approval Gates**: Each phase requires explicit user approval before proceeding
2. **Test-Driven**: Requirements written for testability, implementation starts with tests
3. **Incremental Progress**: Work in small, verifiable chunks
4. **Documentation**: Keep docs current throughout the process
5. **Fact-Based**: Document only what is implemented, not assumptions
6. **Review-Friendly**: Tasks grouped into manageable PRs for easier review

## Typical Flow

1. Start with `/spec:init my-feature`
2. Define requirements with `/spec:requirements my-feature`
3. Create design with `/spec:design my-feature`
4. Break down work with `/spec:tasks my-feature`
5. Implement each task with `/spec:implement my-feature`
6. Complete feature with `/spec:complete my-feature`
7. Update steering if needed with `/steering:update`

## Best Practices

- Complete each phase before moving to the next
- Use steering documents to maintain consistency
- Keep requirements testable and specific
- Design before coding
- Implement one task at a time
- Update documentation as you go
- Create ADRs for significant decisions
