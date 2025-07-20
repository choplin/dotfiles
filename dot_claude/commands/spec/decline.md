---
description: Decline or abandon a feature specification
allowed-tools: mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Decline Feature Specification

**Feature**: $ARGUMENTS

## Prerequisites Check

Check if spec exists at `specs/$ARGUMENTS/metadata`.

**STOP** if spec doesn't exist. The feature specification must exist to be declined.

## Task: Decline Specification

**SCOPE**: This command marks a feature specification as declined/abandoned, documenting the reason and preserving the work for potential future reference.

### Step 1: Gather Current Status

1. Retrieve metadata from `specs/$ARGUMENTS/metadata`
2. Check current phase and completion status
3. Display current state:

   ```
   ## Current Specification Status

   Feature: {feature-name}
   Phase: {current-phase}

   Progress:
   - Requirements: {generated/approved/not-started}
   - Design: {generated/approved/not-started}
   - Tasks: {generated/approved/not-started}
   - Implementation: {X tasks completed / Y total}
   ```

### Step 2: Request Decline Reason

Ask user:

```
Why is this specification being declined?

Common reasons:
1. Business priorities changed
2. Technical approach not feasible
3. Requirements changed significantly
4. Resource constraints
5. Duplicate of another feature
6. Other (please specify)

Please provide the reason:
```

### Step 3: Document Lessons Learned (Optional)

Ask user:

```
Are there any lessons learned or insights from this specification work that should be documented?
(This helps inform future specifications)

Document lessons? (yes/no)
```

If yes, collect:

- What worked well
- What challenges were encountered
- Recommendations for similar features

### Step 4: Update Metadata

Update `specs/$ARGUMENTS/metadata` with decline information:

```yaml
# Spec Metadata
## Feature
- Name: $ARGUMENTS
- Description: [original description]

## Approvals
### Requirements
- Generated: [true/false]
- Approved: [true/false]
### Design
- Generated: [true/false]
- Approved: [true/false]
### Tasks
- Generated: [true/false]
- Approved: [true/false]

## Implementation
- Status: declined
- Declined Date: [today's date]
- Decline Reason: [user-provided reason]
- Tasks Completed: X/Y
- Lessons Learned: |
  [if provided]

## Phase
- Current: declined
- Previous: [what phase it was in]
```

### Step 5: Preserve Work

Inform user:

```
## Specification Declined

The specification for {feature-name} has been marked as declined.

### Preserved Data
All work remains in vault for future reference:
- Requirements: specs/{feature-name}/requirements
- Design: specs/{feature-name}/design
- Tasks: specs/{feature-name}/tasks
- Metadata: specs/{feature-name}/metadata

### Reason Documented
{decline-reason}

### Next Steps
- This specification can be revived later if needed
- Use `/spec:init {feature-name}` to restart (will prompt to use existing data)
- Consider creating a new spec if requirements have changed significantly
```

### Step 6: Check for Cleanup Needs

Ask user:

```
Do you want to:
1. Keep any feature branches created for this spec?
2. Archive or clean up any work-in-progress code?

Cleanup needed? (yes/no)
```

If yes, provide guidance on:

- Listing feature branches
- Archiving or deleting branches
- Preserving any valuable code snippets

---

## Output Format

Show:

1. Original spec status summary
2. Decline reason recorded
3. Confirmation that data is preserved
4. Clear indication of how to revive if needed
5. Any cleanup recommendations
