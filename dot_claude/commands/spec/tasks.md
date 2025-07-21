---
description: Generate implementation tasks for a specification
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Implementation Tasks

**Feature**: $ARGUMENTS

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
- Leaf tasks: `- [ ] 1.1.1 Task description [S] [REQ-001]` (WITH checkbox)

**Task Granularity (CRITICAL)**:

- **Each task = One commit after Red-Green-Refactor cycle**
- Break down features into smallest testable behaviors
- If a task feels too large, split it into smaller behaviors

**Size Guidelines**:

- **S (Small)**: Single behavior, 1-2 test cases
- **M (Medium)**: Related behavior, 3-5 test cases
- **L (Large)**: Complex behavior, 6+ test cases (consider splitting)

**t-wada Style TDD Approach**:

- **DO NOT create separate test and implementation tasks**
- Each task represents ONE complete TDD cycle ending in a commit
- Task name should describe ONE specific behavior
- Examples:
  - "Implement email format validation [S] [REQ-001/AC-001.2]"
  - "Handle duplicate email registration error [S] [REQ-001/AC-001.3]"
  - "Store user data with encrypted password [M] [REQ-001/AC-001.1]"
- Avoid broad tasks like "Implement user registration" - break it down

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

| Requirement                | Acceptance Criteria      | Tasks        | Coverage |
| -------------------------- | ------------------------ | ------------ | -------- |
| REQ-001: User Registration | AC-001.1 (normal flow)   | 1.2.1, 1.2.2 | ✓        |
|                            | AC-001.2 (validation)    | 2.1.1, 2.1.2 | ✓        |
|                            | AC-001.3 (error case)    | 2.3.1        | ✓        |
| REQ-002: Email Validation  | AC-002.1 (format check)  | 1.3.1, 1.3.2 | ✓        |
|                            | AC-002.2 (invalid email) | 1.3.3        | ✓        |

## Branch Strategy

- Main feature branch: feature/{feature-name}
- PR #1 after tasks 1.1-1.3
- PR #2 after tasks 2.1-2.4
- Final PR after all tasks

## Tasks

### 1.0 Foundation Setup

#### 1.1 Project Configuration

- [ ] 1.1.1 Set up feature flag for {feature} [S]
- [ ] 1.1.2 Update dependencies if needed [S]

#### 1.2 User Registration

- [ ] 1.2.1 Validate email format [S] [REQ-001/AC-001.2]
- [ ] 1.2.2 Reject invalid email with error message [S] [REQ-001/AC-001.3]
- [ ] 1.2.3 Create user record with valid email [S] [REQ-001/AC-001.1]
- [ ] 1.2.4 Hash password before storing [S] [REQ-001/AC-001.4]
- [ ] 1.2.5 Handle duplicate email error [S] [REQ-001/AC-001.5]

--- PR #1: Foundation (Tasks 1.1-1.2) ---

### 2.0 Core Features

#### 2.1 API Endpoints

- [ ] 2.1.1 Return 200 for valid GET request [S] [REQ-002/AC-002.1]
- [ ] 2.1.2 Return user data in JSON format [S] [REQ-002/AC-002.1]
- [ ] 2.1.3 Return 400 for missing parameters [S] [REQ-002/AC-002.2]
- [ ] 2.1.4 Return 404 for non-existent user [S] [REQ-002/AC-002.3]
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

   Note: Each task includes both test writing and implementation (t-wada TDD style)
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
