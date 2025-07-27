---
description: Generate implementation tasks for a specification
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Implementation Tasks

**Feature**: $ARGUMENTS

# Check arguments and list specs if needed
`~/.claude/scripts/spec-common.sh tasks`

## Prerequisites Check

**CRITICAL**: Verify both requirements and design are approved before proceeding.

Check metadata at `specs/$ARGUMENTS/metadata` for:

- **Approvals > Requirements > Approved**: must be true
- **Approvals > Design > Approved**: must be true
- **Phase**: should be "design-approved"

**STOP** if either is not approved. Direct user to complete approvals first.

## Task: Generate Implementation Plan

**SCOPE**: This command ONLY generates implementation tasks. It does not:

- Modify requirements or design
- Write any code
- Execute any tasks
- Create any other documentation

Create comprehensive implementation plan based on approved requirements and design:

### Step 1: Gather Context

Retrieve from vault:

- Approved requirements from `specs/$ARGUMENTS/requirements`
- Approved design from `specs/$ARGUMENTS/design`
- Spec metadata from `specs/$ARGUMENTS/metadata` (for language)
- Steering documents if available (`steering/structure`, `steering/tech`, `steering/product`)

### Step 2: Determine Branch Strategy

Before generating tasks, determine the branching and PR strategy:

1. Analyze the feature scope and complexity
2. Consider reviewer capacity
3. Group related work into logical PR units

Present strategy for approval:

```
## Branch & PR Strategy

**Feature Branch**: feature/{feature-name}

**PR Breakpoints** (proposed):
1. **PR #1 - Foundation**: [description of what's included]
   - Estimated size: ~X files, Y lines
   - Review focus: [what reviewers should focus on]

2. **PR #2 - Core Implementation**: [description]
   - Estimated size: ~X files, Y lines
   - Review focus: [what to review]

3. **PR #3 - [Additional PRs as needed]**

**Rationale**: [explain why this breakdown makes sense]

Do you approve this branch strategy? (yes/no/modify)
```

Wait for approval before proceeding.

### Step 3: Generate Tasks Document

Create a WBS (Work Breakdown Structure) based on the approved design and requirements.

**CRITICAL: Requirements-Task Mapping**:

1. First, list all requirements from the spec
2. Ensure EVERY requirement has corresponding tasks
3. Map each task to specific requirement(s)
4. Verify no requirements are left without implementation tasks

**WBS Structure**:

- Use hierarchical numbering (1.0 → 1.1 → 1.1.1)
- Maximum 3 levels deep
- **IMPORTANT: Use Markdown checkbox format for ALL leaf tasks**: `- [ ] task description`
- Only leaf tasks (lowest level) should have checkboxes
- Each leaf task should be sized as S/M/L
- Include size estimates and requirement references
- **Mark PR breakpoints with special notation**: `--- PR #1: Foundation ---`

**Task Format (MUST follow exactly)**:

- Parent sections: `### 1.0 Section Name` (no checkbox)
- Sub-sections: `#### 1.1 Sub-section Name` (no checkbox)
- Feature tasks: `- [ ] 1.1.1 Feature/Component description [S] [REQ-001]` (WITH checkbox)
- TDD details: Listed as sub-items under each feature task (no checkbox)

**Task Granularity (CRITICAL)**:

- **Each task = One actionable feature or component**
- Tasks should be meaningful units of work, not individual test cases
- TDD details provide the specific behaviors to implement within each task

**Size Guidelines**:

- **S (Small)**: Single feature or component (2-4 hours of work)
- **M (Medium)**: Related feature set (4-8 hours of work)
- **L (Large)**: Complex feature group (1-2 days of work)
- **XL (Extra Large)**: Major feature requiring 3+ days (must split into L or smaller)

**t-wada Style TDD Approach**:

- **Each task includes both test and implementation**
- Tasks are feature-oriented, not test-oriented
- TDD details list the specific behaviors to test-drive within each feature
- Examples:
  - Task: "User Registration API endpoint [M] [REQ-001]"
    - TDD details:
      - Email format validation [AC-001.2]
      - Invalid email error response [AC-001.3]
      - User record creation with hashed password [AC-001.1, AC-001.4]
      - Duplicate email detection [AC-001.5]
- Within each task, apply Red-Green-Refactor for each TDD detail

**Include tasks for**:

- Project setup and configuration
- Data models and database implementation
- API endpoints and backend services
- Frontend components and UI
- Integration and testing (unit, integration, E2E)
- Documentation

**Example Structure**:

```markdown
# Implementation Tasks: {feature-name}

## Requirements Coverage Matrix

| Requirement                | Acceptance Criteria      | Tasks | Coverage |
| -------------------------- | ------------------------ | ----- | -------- |
| REQ-001: User Registration | AC-001.1 (normal flow)   | 1.2   | ✓        |
|                            | AC-001.2 (validation)    | 1.2   | ✓        |
|                            | AC-001.3 (error case)    | 1.2   | ✓        |
| REQ-002: User Query API    | AC-002.1 (normal query)  | 2.1   | ✓        |
|                            | AC-002.2 (error cases)   | 2.1   | ✓        |

## Branch Strategy

- Main feature branch: feature/{feature-name}
- PR #1 after tasks 1.1-1.2
- PR #2 after tasks 2.1-2.2
- Final PR after all tasks

## Tasks

### 1.0 Foundation Setup

#### 1.1 Project Configuration

- [ ] 1.1.1 Set up feature configuration and dependencies [S]
  TDD details:
  - Feature flag configuration
  - Dependencies update if needed

#### 1.2 User Registration

- [ ] 1.2.1 User Registration API endpoint [M] [REQ-001]
  TDD details:
  - Email format validation [AC-001.2]
  - Invalid email error response [AC-001.3]
  - User record creation with password hashing [AC-001.1, AC-001.4]
  - Duplicate email detection [AC-001.5]

--- PR #1: Foundation (Tasks 1.1-1.2) ---

### 2.0 Core Features

#### 2.1 API Endpoints

- [ ] 2.1.1 User Query API endpoint [M] [REQ-002]
  TDD details:
  - Return 200 and user data for valid request [AC-002.1]
  - Return 400 for missing parameters [AC-002.2]
  - Return 404 for non-existent user [AC-002.2]
  - JSON response format validation [AC-002.1]
```

### Step 4: Verify MECE Coverage

Before requesting approval, verify:

1. **Completeness Check**: Every requirement has at least one task
2. **Coverage Check**: All acceptance criteria (normal, error, edge) are covered
3. **No Overlap**: Tasks don't duplicate effort
4. **Present Coverage Summary**:

   ```
   ## Requirements Coverage Summary

   Total Requirements: X
   Covered Requirements: X (100%)

   Coverage by Type:
   - Normal flows: Y tasks
   - Error handling: Z tasks
   - Edge cases: W tasks

   Note: Each task is a feature/component that will be implemented using TDD.
   The TDD details under each task show the specific behaviors to test-drive.
   ```

### Step 5: Request User Approval

Present generated tasks and ask:

```
Implementation tasks complete. Please review the task list.

Do you approve these tasks?
- If yes: I will save to vault and update approval status
- If no: Please provide feedback for revision
```

### Step 6: Handle User Response

**If approved**:

1. Save tasks to `specs/$ARGUMENTS/tasks`
2. Update metadata at `specs/$ARGUMENTS/metadata`:
   - Phase: ready-for-implementation
   - Approvals > Tasks > Generated: true
   - Approvals > Tasks > Approved: true
   - Ready for Implementation: true
3. Proceed to Output Format section

**If revision needed**:

1. Update tasks based on feedback (keep in memory)
2. Return to Step 4 (Verify MECE Coverage)

**Continue iterating until approval**

---

## Output Format

After tasks are approved:

1. Display confirmation: "Implementation tasks approved ✓"
2. Show updated vault keys:
   - `specs/$ARGUMENTS/tasks` - Approved task list
   - `specs/$ARGUMENTS/metadata` - Updated with approval status
3. Present completion message:

   ```
   All specifications are now approved and ready for implementation!

   Next step: Start implementing the first task
   Run: /spec:implement {feature-name}
   ```
