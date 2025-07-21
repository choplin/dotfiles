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

**WBS Structure**:

- Use hierarchical numbering (1.0 → 1.1 → 1.1.1)
- Maximum 3 levels deep
- **IMPORTANT: Use Markdown checkbox format for ALL leaf tasks**: `- [ ] task description`
- Only leaf tasks (lowest level) should have checkboxes
- Each leaf task should be 2-4 hours
- Include time estimates and requirement references
- **Mark PR breakpoints with special notation**: `--- PR #1: Foundation ---`

**Task Format (MUST follow exactly)**:

- Parent sections: `### 1.0 Section Name` (no checkbox)
- Sub-sections: `#### 1.1 Sub-section Name` (no checkbox)
- Leaf tasks: `- [ ] 1.1.1 Task description (2h) [REQ-001]` (WITH checkbox)

**TDD Approach**:

- For each feature task, create a corresponding test task FIRST
- Test tasks should verify the requirement's acceptance criteria
- Pattern: "Write test for [requirement]" → "Implement [feature]"
- Tests must be written based on EARS-format acceptance criteria from requirements

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

## Branch Strategy

- Main feature branch: feature/{feature-name}
- PR #1 after tasks 1.1-1.3
- PR #2 after tasks 2.1-2.4
- Final PR after all tasks

## Tasks

### 1.0 Foundation Setup

#### 1.1 Project Configuration

- [ ] 1.1.1 Set up feature flag for {feature} (0.5h)
- [ ] 1.1.2 Update dependencies if needed (0.5h)

#### 1.2 Data Models

- [ ] 1.2.1 Write tests for User model changes (1h) [REQ-001]
- [ ] 1.2.2 Implement User model changes (1h) [REQ-001]

--- PR #1: Foundation (Tasks 1.1-1.2) ---

### 2.0 Core Features

#### 2.1 API Implementation

- [ ] 2.1.1 Write tests for GET /api/feature (2h) [REQ-002]
- [ ] 2.1.2 Implement GET /api/feature (2h) [REQ-002]
```

### Step 4: Request User Approval

Present generated tasks and ask:

```
Implementation tasks complete. Please review the task list.

Do you approve these tasks?
- If yes: I will save to vault and update approval status
- If no: Please provide feedback for revision
```

### Step 5: Handle User Response

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
2. Return to Step 4

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
