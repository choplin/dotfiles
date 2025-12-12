---
date: 2025-07-21
title: Spec-Driven Development Command Reference
---

# Command Reference

## Spec Commands

### /spec:init

**Purpose**: Initialize a new feature specification

**Usage**: `/spec:init {feature-name}`

**Actions**:
- Interprets brief project descriptions
- Presents interpretation for approval
- Creates initial metadata in vault
- Sets up specification structure
- Tracks approval states

**Output**: Confirmation and next steps

---

### /spec:requirements

**Purpose**: Generate requirements in EARS format

**Usage**: `/spec:requirements {feature-name}`

**Prerequisites**: Spec must be initialized

**Actions**:
- Analyzes feature goals
- Creates testable requirements with REQ-* labels
- Uses EARS format with AC-* labels for acceptance criteria
- Includes normal, error, and edge cases
- Performs MECE coverage check
- Requests user approval

**Output**: Requirements document with coverage analysis

---

### /spec:design

**Purpose**: Create technical design document

**Usage**: `/spec:design {feature-name}`

**Prerequisites**: Requirements must be approved

**Actions**:
- Analyzes existing implementation for consistency
- Creates architecture overview aligned with patterns
- Prefers Markdown, uses diagrams when necessary
- Defines components and interfaces
- Documents implementation approach with regression prevention
- Maps design elements to requirements
- Requests user approval

**Output**: Comprehensive design document with requirement traceability

---

### /spec:tasks

**Purpose**: Generate task breakdown (WBS) with branch strategy

**Usage**: `/spec:tasks {feature-name}`

**Prerequisites**: Design must be approved

**Actions**:
- Proposes branch strategy and PR breakpoints
- Creates Work Breakdown Structure
- Maximum 3 levels deep
- S/M/L size estimates (no hours)
- Each task includes tests AND implementation (t-wada TDD)
- Maps tasks to requirements/acceptance criteria
- Verifies MECE coverage
- Marks PR submission points
- Requests user approval

**Output**: Structured task list with coverage matrix

---

### /spec:implement

**Purpose**: Implement one task at a time

**Usage**: `/spec:implement {feature-name}`

**Prerequisites**: All specs must be approved

**Actions**:
1. Selects next unchecked task
2. Shows implementation plan for approval
3. Manages branches per task strategy
4. Implements using t-wada style TDD (Red-Green-Refactor)
5. Commits only after Refactor phase complete
6. Updates task status and work log
7. Notifies at PR breakpoints
8. Analyzes and suggests steering updates
9. Prompts next action based on remaining tasks

**Output**: Completed task with commit info, work log, and next steps

---

### /spec:complete

**Purpose**: Finalize feature implementation

**Usage**: `/spec:complete {feature-name}`

**Prerequisites**: All tasks should be completed

**Actions**:
- Verifies requirements coverage
- Runs all tests
- Checks code quality
- Updates CHANGELOG
- Updates documentation
- Saves design doc (if needed)
- Suggests ADRs
- Updates metadata

**Output**: Completion summary and next steps

---

### /spec:decline

**Purpose**: Decline or abandon a feature specification

**Usage**: `/spec:decline {feature-name}`

**Prerequisites**: Spec must exist

**Actions**:
- Shows current progress
- Records decline reason
- Preserves all work in vault
- Documents lessons learned
- Updates metadata status

**Output**: Decline confirmation and preservation details

---

## Steering Commands

### /steering:init

**Purpose**: Create initial steering documents

**Usage**: `/steering:init`

**Actions**:
- Creates product vision document
- Creates technical decisions document
- Creates project structure document
- Requests approval for each

**Output**: Three foundational documents in vault

---

### /steering:update

**Purpose**: Update steering documents

**Usage**: `/steering:update`

**Actions**:
- Reviews recent changes
- Identifies updates needed
- Updates relevant documents
- Only significant changes
- Requests approval

**Output**: Updated steering documents

---

## Vault Structure

All data stored in Vault MCP with this structure:

```
steering/
├── product      # Product vision, users, value
├── tech         # Technical stack, patterns
└── structure    # Directory layout, conventions

specs/{feature}/
├── metadata     # Approval states, status
├── requirements # EARS-format requirements
├── design       # Technical design document
└── tasks        # Task breakdown (WBS)
```

## Approval Workflow

Each command follows this pattern:
1. Check prerequisites
2. Generate content
3. Present for review
4. Allow iterations
5. Save to vault only after approval

## Command Patterns

### Arguments
- `{feature-name}`: Kebab-case feature identifier
- No arguments: Commands that work globally

### States
Commands check and update states:
- `pending`: Not yet started
- `generated`: Created but not approved
- `approved`: User has approved
- `completed`: Implementation finished

### Error Handling
- Prerequisites not met → Clear error message
- Missing data → Guided recovery
- Conflicts → User decision required