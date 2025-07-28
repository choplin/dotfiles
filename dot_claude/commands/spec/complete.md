---
description: Complete the feature implementation and finalize all documentation
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list, TodoWrite
---

# Complete Feature Implementation

@~/.claude/references/spec-common.md - Vault structure and common operations

**Feature**: $ARGUMENTS

# Check arguments and list specs if needed
`~/.claude/scripts/spec-common.sh complete`

## Prerequisites Check

**CRITICAL**: Verify all tasks are completed before proceeding.

Retrieve tasks from vault and check for:
- All tasks marked with `[x]`
- No remaining `[ ]` tasks

**If tasks remain incomplete**:
- Ask user if they want to proceed anyway
- If yes, mark spec as "partially-completed" in metadata
- If no, direct them to continue with `/spec:implement`

## Task: Finalize Implementation

**SCOPE**: This command performs final verification and documentation updates after all implementation tasks are complete.

### Step 1: Verify Requirements Coverage

1. Retrieve requirements from vault
2. For each requirement:
   - Identify corresponding test files
   - Verify test exists for each acceptance criterion
   - List any missing test coverage

Present findings:
```
## Requirements Coverage Report

✓ REQ-001: [requirement] - Tests: test_file.py
✓ REQ-002: [requirement] - Tests: test_file2.py
✗ REQ-003: [requirement] - Missing test coverage

Coverage: X/Y requirements have tests
```

### Step 2: Run All Tests

1. Execute the project's test suite
2. Capture results
3. If any tests fail:
   - Show failing tests
   - Ask if user wants to fix them first
   - Offer to continue anyway (document as known issues)

### Step 3: Run Quality Checks

1. Execute lint/format/type checking commands
2. If errors found:
   - Display errors
   - Ask if user wants to fix them first
   - Offer to continue anyway

### Step 4: Update CHANGELOG

1. Check if CHANGELOG.md exists
2. Prepare entry based on:
   - Feature name and description
   - Completed requirements
   - Breaking changes (if any)
3. Follow Keep a Changelog format:
   ```
   ## [Unreleased]
   ### Added
   - Feature: [description]
   - [List key capabilities added]
   ```
4. Show proposed entry for approval
5. Update file after approval

### Step 5: Update Documentation

1. Identify documentation that needs updates:
   - README.md (if feature is user-facing)
   - API documentation
   - Configuration docs
2. For each file needing updates:
   - Show proposed changes
   - Get approval
   - Apply updates

### Step 6: Save Design Document (if significant)

Ask user:
```
Was this a significant feature that should have its design document preserved in the repository?
(Significant = major architectural change, new subsystem, complex feature)

Save design doc? (yes/no)
```

If yes:
1. Retrieve design from vault
2. Save to `docs/design/{feature-name}.md`
3. Add frontmatter with date and feature name

### Step 7: Check for ADR Needs

Review implementation history and ask:
```
Were there any important technical decisions made during implementation that should be documented as ADRs?

Examples:
- Choice of library/framework
- Algorithm selection
- Trade-off decisions
- Architecture patterns

Any ADRs needed? (yes/no)
```

If yes:
```
Please run `/workflow:adr` to create ADRs for:
- [List suggested ADR topics]
```

### Step 8: Update Vault Metadata

1. Retrieve current metadata from vault
2. Update the metadata with the following information:
```yaml
# Spec Metadata
## Feature
- Name: $ARGUMENTS
- Description: [description]

## Approvals
### Requirements
- Generated: true
- Approved: true
### Design
- Generated: true
- Approved: true
### Tasks
- Generated: true
- Approved: true

## Implementation
- Status: completed
- Completed Date: [today's date]
- Test Coverage: X/Y requirements
- Quality Checks: passed/passed with warnings

## Phase
- Current: completed
```

3. Save the updated metadata back to vault.

### Step 9: Identify Outstanding Items

Compile list of:
1. Uncovered requirements (if any)
2. Failed tests (if proceeding anyway)
3. Quality issues (if proceeding anyway)
4. Documentation gaps
5. Suggested follow-up tasks

Present as:
```
## Outstanding Items

### Must Address Later
- [Critical items that need fixing]

### Consider for Future
- [Enhancements or optimizations]
- [Additional test scenarios]
- [Documentation improvements]
```

### Step 10: Final Summary

Present completion summary:
```
## Feature Implementation Complete: {feature-name}

### Summary
- Requirements implemented: X/Y
- Tests passing: Y/Z
- Documentation updated: ✓
- CHANGELOG updated: ✓

### Next Steps
1. Create PR to merge feature branch
2. Review outstanding items (if any)
3. Consider follow-up features

Spec completed successfully!
```

---

## Output Format

Show:
1. Coverage and test results
2. Documentation updates made
3. Outstanding items (if any)
4. Completion status in metadata
5. Clear next steps for the user