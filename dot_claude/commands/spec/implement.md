---
description: Implement a task from the approved task list using TDD
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list, TodoWrite
---

# Task Implementation

@~/.claude/references/spec-common.md - Vault structure and common operations

**Feature**: $ARGUMENTS

# Check arguments and list specs if needed

`~/.claude/scripts/spec-common.sh implement`

## Prerequisites Check

**CRITICAL**: Check metadata from vault:

- Ready for Implementation: must be true
- Phase: must be "ready-for-implementation"
  STOP if not ready - complete approvals first.

## Task: Implement Next Task

**SCOPE**: Implements ONE task at a time using TDD, managing branches and updating status

### Step 1: Review Work Log and Select Task

1. Check for existing work log in vault
   - If exists, display recent entries to understand context
   - Show last completed task and any noted challenges
2. Retrieve tasks from vault
3. Find the first unchecked task (- [ ])
4. Display selected task to user
5. Extract branch strategy from tasks document

### Step 2: Plan Implementation with Context

1. Check branch strategy from tasks document
2. Determine branch action:
   - First task in feature → create feature branch
   - After PR merge → create from main
   - Otherwise → continue on existing branch

3. Gather implementation context from vault:
   - Requirements
   - Design
   - Steering documents if available
   - Extract: requirement IDs, design specs, code patterns, tech stack

4. Analyze task to create TDD plan:
   - Task type: UI/API → BDD focus; Internal/Utilities → xUnit focus
   - File paths from project structure
   - Quality check commands from package.json/Makefile/.pre-commit
   - **CRITICAL**: Use ACTUAL code, REAL paths, CONCRETE test data

Present the execution plan:

````
## Implementation Plan

**Task**: [Insert actual task number and full description]
**Current Branch**: [Insert output of 'git branch --show-current']
**Branch Action**: [Insert actual branch action]

## Red-Green-Refactor Cycle Execution Plan

[For each acceptance criterion, create a detailed TDD cycle plan]

### Acceptance Criterion 1: "[Insert actual acceptance criterion text]"

**🔴 Red Phase (Write Failing Test)**
- Test File: `[Insert actual test file path]`
- Expected: [error type] - [error message]

```[language]
[Insert actual test code with Given-When-Then or Arrange-Act-Assert]
[Show concrete test data and assertions]
```

**🟢 Green Phase (Minimal Implementation)**

- Implementation File: `[Insert actual implementation file path]`
- Test Command: `[Insert actual test command]`

```[language]
[Insert minimal code that makes the test pass]
[Can include hardcoded values or simple logic]
```

**🔄 Refactor Phase (Improve Code)**

1. [Specific refactoring action #1]
2. [Specific refactoring action #2]
3. [Specific refactoring action #3]

```[language]
[Insert refactored code snippet showing key improvements]
```

[Repeat for each acceptance criterion]

## TDD Progress

- [ ] Criterion 1: [short description]
- [ ] Criterion 2: [short description]
- [ ] Criterion 3: [short description]

## Quality Checks

- Test: `[Insert test command]`
- Lint: `[Insert lint command]`
- Type: `[Insert type check command]` (if applicable)

## Final Commit

```
[type]([scope]): [descriptive message]

- [what was implemented]
- [based on acceptance criteria]
```

Do you approve this plan? (yes/no)
````

### Step 3: Handle Branch

**Only after approval**: Execute branch action from plan

### Step 4: Implement with t-wada Style TDD

**Note**: Don't test mocks, helpers, or test utilities - they're test infrastructure

Execute the approved Red-Green-Refactor plan for each acceptance criterion:

For each acceptance criterion:

#### Red Phase

1. Create/edit test file and write test code from plan
2. Run test and verify failure
3. Display: `🔴 Red: [test file] - FAILED ❌ [error message]`

#### Green Phase

1. Create/edit implementation file with minimal code
2. Run test and verify pass
3. Display: `🟢 Green: [test file] - PASSED ✅`

#### Refactor Phase

1. Apply refactoring actions from plan
2. Verify tests still pass
3. Display: `🔄 Refactor: Applied [actions] - All tests passing ✅`

#### Progress Tracking

After each cycle, show:

```

TDD Progress:
✅ Criterion 1: [description]
🔴 Criterion 2: [description] (currently in Red phase)
⬜ Criterion 3: [description]

```

### Step 5: Complete Implementation

1. Ensure all acceptance criteria are covered
2. Verify implementation follows steering patterns
3. Run full test suite

### Step 6: Verify All Tests

1. Run all existing tests
2. Fix any broken tests
3. Ensure entire test suite passes

### Step 7: Code Quality Checks

1. Run repository's pre-commit checks (lint, format, type check)
2. Fix any issues found
3. Ensure code meets quality standards

### Step 10: Implementation Approval and Commit

1. Present implementation summary:

```

Task complete: [task description]

- Tests: All passing ✓
- Code quality: Checked ✓

Approve and commit? (yes/no)

```

2. If approved:

- Create commit with conventional format
- Update tasks in vault (mark completed with [x])

3. If changes needed:

- Make requested changes
- Re-run tests and return to step 1

### Step 11: Update Task Status

1. Retrieve tasks from vault
2. Mark completed task with `[x]`
3. Check if PR breakpoint reached (look for `--- PR #X ---` marker)
4. Save updated tasks back to vault
5. Show remaining tasks count

### Step 12: Check for PR Breakpoint

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

### Step 13: Update Work Log

Create or append to work log in vault:

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

Save work log to vault.

### Step 14: Check for Steering Updates

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
