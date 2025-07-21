---
description: Implement a task from the approved task list using TDD
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list, TodoWrite
---

# Task Implementation

**Feature**: $ARGUMENTS

## Prerequisites Check

**CRITICAL**: Verify all specifications are approved before proceeding.

Check metadata at `specs/$ARGUMENTS/metadata` for:

- **Ready for Implementation**: must be true
- **Phase**: should be "ready-for-implementation"

**STOP** if not ready. Direct user to complete all approvals first.

## Task: Implement Next Task

**SCOPE**: This command implements ONE task at a time. It:

- Follows TDD approach (test first, then implement)
- Manages branches according to task strategy
- Updates task status upon completion

### Step 1: Select Task

1. Retrieve tasks from `specs/$ARGUMENTS/tasks`
2. Find the first unchecked task (- [ ])
3. Display selected task to user
4. Extract branch strategy from tasks document

### Step 2: Plan Implementation

1. Check branch strategy from tasks document
2. Determine if new branch needed or use existing:
   - If first task in feature: create feature branch
   - If continuing after PR merge: create from main
   - Otherwise: continue on existing branch
3. Create implementation plan including:
   - Selected task details
   - Branch action (create new/continue existing)
   - TDD approach steps
   - Expected test files
   - Expected implementation files

### Step 3: Request User Approval

Present the execution plan:

```
## Implementation Plan

**Task**: [selected task description]
**Current Branch**: [current branch name]
**Branch Action**: [Create new branch: feature/{name} | Continue on existing branch]

**Execution Steps**:
1. [Create/Switch to branch if needed]
2. TDD Cycle (t-wada style):
   - Red: Write failing test
   - Green: Minimal code to pass
   - Refactor: Clean up
   - Repeat for each acceptance criterion
3. Verify all tests pass
4. Run code quality checks
5. Commit changes

**Test Files to Create**:
- [test file paths]

**Implementation Files**:
- [implementation file paths]

Do you approve this plan? (yes/no)
```

Wait for user approval before proceeding.

### Step 4: Handle Branch

**Only after approval**:

1. Execute branch action based on plan:
   - If creating new branch: `git checkout -b {branch-name}`
   - If continuing: verify on correct branch
   - If after PR merge: ensure main is up to date first

### Step 5: Gather Implementation Context

Retrieve from vault:

- Requirements from `specs/$ARGUMENTS/requirements`
- Design from `specs/$ARGUMENTS/design`
- Steering documents:
  - `steering/structure`
  - `steering/tech`
  - `steering/product`

Identify:

- Which requirement(s) this task implements
- Design specifications for this component
- Existing patterns to follow

### Step 6: Implement with t-wada Style TDD

1. Follow t-wada style TDD strictly (Red-Green-Refactor cycle)
2. Based on requirement's EARS-format acceptance criteria
3. **IMPORTANT**: Complete full cycle including Refactor phase before any commits
4. Continue cycles until all acceptance criteria are covered

### Step 7: Complete Implementation

After TDD cycles are complete:

1. Ensure all acceptance criteria are covered by tests
2. Verify implementation follows patterns from steering documents
3. Check alignment with design specifications
4. Run full test suite one final time

### Step 8: Verify All Tests

1. Run all existing tests
2. Fix any broken tests
3. Ensure entire test suite passes

### Step 9: Code Quality Checks

1. Run repository's pre-commit checks (lint, format, type check)
2. Fix any issues found
3. Ensure code meets quality standards

### Step 10: Request User Approval

Present implementation and ask:

```
Task implementation complete:
- Task: [task description]
- Tests: All passing ✓
- Code quality: Checked ✓

Do you approve this implementation?
- If yes: I will commit the changes
- If no: What needs to be changed?
```

### Step 11: Commit Changes

**If approved**:

1. Verify all TDD cycles are complete (including Refactor phase)
2. Create commit with conventional format
3. Update tasks in vault (mark completed with [x])
4. Proceed to Step 12

**If changes needed**:

1. Make requested changes
2. Re-run tests and checks
3. Return to Step 10

### Step 12: Update Task Status

1. Retrieve tasks from `specs/$ARGUMENTS/tasks`
2. Mark completed task with `[x]`
3. Check if PR breakpoint reached (look for `--- PR #X ---` marker)
4. Save updated tasks back to vault
5. Show remaining tasks count

### Step 13: Check for PR Breakpoint

If PR breakpoint marker found after current task:

```
## PR Breakpoint Reached!

You've completed all tasks for PR #{number}: {pr-title}

**Completed tasks**: [list of task numbers]
**Branch**: {current-branch}

### Next Steps:
1. Review all changes: git diff main...HEAD
2. Push branch: git push -u origin {branch-name}
3. Create PR with title: "{pr-title}"
4. Wait for review and merge

Continue with next tasks? (yes/no)
```

If user says no, remind them to run `/spec:implement {feature-name}` after PR is merged.

### Step 14: Update Work Log

Create or append to work log in vault at `specs/$ARGUMENTS/work-log`:

```markdown
## [Current Date] - Task: [task number and description]

### What was done
- [List of specific changes made]
- [Files created/modified]
- [Tests written]

### Decisions made
- [Any technical decisions during implementation]
- [Trade-offs considered]

### Challenges encountered
- [Any difficulties or unexpected issues]
- [How they were resolved]

### Commit
- Hash: [commit hash]
- Message: [commit message]
```

Save using `mcp__vault__vault_set`.

### Step 15: Check for Steering Updates

Ask user:

```
Task completed. Does this implementation introduce changes that should be reflected in steering documents?
(New patterns, technologies, or architectural decisions)

Update steering documents? (yes/no)
```

If yes, suggest running `/steering:update`.

---

## Output Format

After successful implementation:

1. Display commit hash and message
2. Show task marked as complete
3. Display remaining tasks count
4. Note next steps based on remaining tasks:

   **If tasks remain**:

   ```
   Task implemented successfully!
   - Remaining tasks: X

   Next step: Continue with the next task
   Run: /spec:implement {feature-name}
   ```

   **If all tasks completed**:

   ```
   Task implemented successfully!
   - All tasks completed! ✓

   Next step: Finalize the feature
   Run: /spec:complete {feature-name}
   ```
