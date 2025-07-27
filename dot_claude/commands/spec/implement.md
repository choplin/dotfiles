---
description: Implement a task from the approved task list using TDD
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list, TodoWrite
---

# Task Implementation

**Feature**: $ARGUMENTS

# Check arguments and list specs if needed

`~/.claude/scripts/spec-common.sh implement`

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

### Step 1: Review Work Log and Select Task

1. Check for existing work log at `specs/$ARGUMENTS/work-log`
   - If exists, display recent entries to understand context
   - Show last completed task and any noted challenges
2. Retrieve tasks from `specs/$ARGUMENTS/tasks`
3. Find the first unchecked task (- [ ])
4. Display selected task to user
5. Extract branch strategy from tasks document

### Step 2: Plan Implementation

1. Check branch strategy from tasks document
2. Determine if new branch needed or use existing:
   - If first task in feature: create feature branch
   - If continuing after PR merge: create from main
   - Otherwise: continue on existing branch
3. Gather detailed information for the plan:
   - Extract task number and full description
   - Retrieve acceptance criteria from requirements
   - Analyze task type to determine test approach:
     - UI/API endpoints/User interactions → BDD focus
     - Internal modules/Utilities/Data models → xUnit focus
   - Identify specific files based on task:
     - Parse task description for component names
     - Use existing project structure to determine paths
   - Detect quality check commands:
     - Check package.json scripts
     - Check Makefile targets
     - Check .pre-commit-config.yaml
4. Create detailed implementation plan with:
   - Each acceptance criterion mapped to TDD cycle
   - Specific file paths based on project structure
   - Actual commands that will be run
   - Realistic commit message based on task
5. **CRITICAL**: When creating the plan:
   - Write ACTUAL test code, not pseudo-code
   - Use REAL file paths from the project structure
   - Include CONCRETE test data and expected values
   - Show EXACT error messages that will occur
   - Provide MINIMAL but WORKING implementation code
   - List SPECIFIC refactoring actions (not generic ones)

### Step 3: Request User Approval

1. Retrieve requirements from `specs/$ARGUMENTS/requirements` to extract acceptance criteria
2. Analyze task to determine specific implementation details
3. Identify existing code patterns from the codebase
4. Determine quality check commands from repository configuration

Present the detailed execution plan:

**IMPORTANT**: Generate a concrete Red-Green-Refactor cycle plan with actual code examples. Show exactly what will be implemented in each phase.

````
## Implementation Plan

**Task**: [Insert actual task number and full description]
**Current Branch**: [Insert output of 'git branch --show-current']
**Branch Action**: [Insert actual branch action]

## Red-Green-Refactor Cycle Execution Plan

[For each acceptance criterion, create a detailed TDD cycle plan]

### Acceptance Criterion 1: "[Insert actual acceptance criterion text]"

#### 🔴 Red Phase (Write Failing Test)
**Test File**: `[Insert actual test file path]`
```[language]
[Insert actual test code that will be written]
[Include Given-When-Then structure or Arrange-Act-Assert]
[Show concrete test data and assertions]
```

**Expected Failure**:

- Error Type: [e.g., NameError, AssertionError]
- Error Message: [Insert expected error message]
- Reason: [Why it will fail - e.g., "Function not yet implemented"]

#### 🟢 Green Phase (Minimal Implementation)

**Implementation File**: `[Insert actual implementation file path]`

```[language]
[Insert minimal code that makes the test pass]
[Can include hardcoded values or simple logic]
[Focus on making test green, not perfect code]
```

**Test Command**: `[Insert actual test command]`
**Expected Result**: ✅ 1 test passed

#### 🔄 Refactor Phase (Improve Code)

**Refactoring Actions**:

1. [Specific refactoring action #1 - e.g., "Extract hardcoded values to configuration"]
2. [Specific refactoring action #2 - e.g., "Extract duplicate code to helper method"]
3. [Specific refactoring action #3 - e.g., "Add error handling"]

**Refactored Code**:

```[language]
[Insert refactored code snippet showing key improvements]
```

[Repeat for each acceptance criterion]

## TDD Cycle Progress Plan

| Acceptance Criterion             | Red | Green | Refactor |
| -------------------------------- | --- | ----- | -------- |
| Criterion 1: [short description] | 🔴  | ⬜    | ⬜       |
| Criterion 2: [short description] | ⬜  | ⬜    | ⬜       |
| Criterion 3: [short description] | ⬜  | ⬜    | ⬜       |

## Quality Checks

**After Each Cycle**:

- `[Insert test command]` - Run tests
- `[Insert lint command]` - Code quality check
- `[Insert type check command]` - Type check (if applicable)

## Final Commit

```
[Insert commit type]([scope]): [Insert descriptive message]

[Insert bullet points of what was implemented]
[Based on actual task and acceptance criteria]
```

Do you approve this plan? (yes/no)
````

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

Analyze and extract:

- Which specific requirement(s) this task implements (by requirement ID/number)
- Exact design specifications for this component from design document
- Concrete code patterns from existing codebase:
  - File naming conventions
  - Test structure patterns
  - Import organization
  - Error handling patterns
- Technology stack details from steering/tech
- Directory structure from steering/structure

Use this information to make implementation decisions that align with existing patterns.

### Step 6: Implement with t-wada Style TDD

**Note**:

- When implementing mocks, helpers, or test utilities, don't write tests for them
- These are test infrastructure and will be tested where they are actually used

**Execution**: Follow the Red-Green-Refactor plan approved in Step 3.

For each acceptance criterion in the approved plan:

#### Execute Red Phase

1. Create/edit the test file as specified in the plan
2. Write the exact test code shown in the plan
3. Run the test command and verify it fails
4. Display the failure output with:

```

## 🔴 Red Phase Result

Acceptance Criterion: [criterion description]
Test File: [file path]
Command: [command]

Result: FAILED ❌
Error: [actual error message]

```

#### Execute Green Phase

1. Create/edit the implementation file as specified
2. Write the minimal code shown in the plan
3. Run the test command and verify it passes
4. Display the success with:

```

## 🟢 Green Phase Result

Implementation File: [file path]
Test Result: PASSED ✅
Tests Passed: [number]

```

#### Execute Refactor Phase

1. Apply each refactoring action listed in the plan
2. Run tests after each change to ensure they still pass
3. Display the completion with:

```

## 🔄 Refactor Phase Complete

Refactorings Applied:
✓ [refactoring action 1]
✓ [refactoring action 2]
✓ [refactoring action 3]

Test Result: All tests passing ✅

```

#### Update Progress Display

After completing each criterion's cycle:

```

## TDD Cycle Progress

| Acceptance Criterion       | Red | Green | Refactor |
| -------------------------- | --- | ----- | -------- |
| Criterion 1: [description] | ✅  | ✅    | ✅       |
| Criterion 2: [description] | 🔴  | ⬜    | ⬜       |
| Criterion 3: [description] | ⬜  | ⬜    | ⬜       |

Currently: Executing Red Phase for Criterion 2...

```

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

Analyze the implementation for steering-worthy changes:

1. **Check for new patterns or conventions**:
   - New coding patterns introduced
   - New file/folder structures created
   - New naming conventions adopted

2. **Check for technical decisions**:
   - New libraries or frameworks added
   - New architectural patterns implemented
   - New integration approaches

3. **Check for product impacts**:
   - New user-facing capabilities
   - Changes to core value proposition

If any of the above are detected, present findings:

```
## Steering Update Analysis

I've identified the following changes that may warrant steering updates:

[List specific changes detected]

Recommendation: Run `/steering:update` to document these changes.
```

If no significant changes detected:

```
No significant steering changes detected in this implementation.
```

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
