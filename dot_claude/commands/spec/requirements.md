---
description: Generate comprehensive requirements for a specification
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Requirements Generation

@~/.claude/references/spec-common.md - Vault structure and common operations

**Feature**: $ARGUMENTS

# Check arguments and list specs if needed
`~/.claude/scripts/spec-common.sh requirements`

## Task: Generate Detailed Requirements

**SCOPE**: This command ONLY generates requirements. It does not:

- Create design documents
- Generate implementation tasks
- Write any code
- Create any other documentation

Create comprehensive requirements document based on the metadata stored in vault:

### Step 1: Gather Context

Retrieve from vault:

- Spec metadata (for language and project description)
- Steering documents if available

### Step 2: Generate Requirements Document

Create requirements document with this structure:

```markdown
# Requirements Specification

## Overview

[Clear overview of the feature and its purpose]

## Requirements

### REQ-001: [Requirement Title]

**User Story:** As a [user type], I want to [do something], so that I can [achieve some goal]

#### Acceptance Criteria

- AC-001.1: WHEN [condition] THEN [system behavior]
- AC-001.2: IF [condition] THEN [system behavior]
- AC-001.3: WHEN [invalid condition] THEN [system SHALL reject/handle error]
- AC-001.4: WHEN [edge case] THEN [specific behavior]

### REQ-002: [Requirement Title]

[Continue with additional requirements following the same pattern]

## MECE Coverage Check

### Input Coverage
- Valid inputs: [list covered scenarios]
- Invalid inputs: [list covered scenarios]
- Edge cases: [list covered scenarios]

### Missing Scenarios
[List any potentially missing scenarios to discuss with user]
```

**Requirements must be**:

- User-centric with clear user stories
- **TESTABLE** - Each EARS criterion must translate to specific test cases for TDD
- **MECE** - Cover all scenarios without overlap:
  - Normal behavior (what users observe)
  - Unwanted behavior (what users should not experience)
  - Edge cases and boundary conditions
- **SMART** - Follow SMART criteria:
  - **Specific**: Clear and unambiguous
  - **Measurable**: Observable and verifiable outcomes
  - **Achievable**: Technically feasible
  - **Relevant**: Aligned with user needs
  - **Time-bound**: Clear conditions for when criteria are met
- Aligned with steering context and system constraints

**EARS Format Guidelines**:
- Keep each criterion on a single line for clarity
- Use bullet points for list formatting
- Include mix of normal, error, and edge cases
- **Label Format**: `AC-XXX.Y` where XXX is requirement number, Y is criterion number

**CRITICAL: User-Observable Behavior Only**:
- Focus on **what users can observe**, not how the system implements it
- **AVOID implementation details** such as:
  - Database operations ("mark in database", "add column", "update flag")
  - Internal system mechanisms ("system SHALL", "remove flag")
  - Technical tool names ("vault_archive tool", "MCP client")
- **USE observable outcomes** such as:
  - What appears/disappears in user interfaces
  - What errors or messages users see
  - What actions become available/unavailable
  - What data users can access or not access

**Good Examples (SMART + User-Observable)**:
- Normal: `AC-001.1: WHEN user archives an entry THEN entry no longer appears in default listings`
- Error: `AC-001.2: WHEN user archives non-existent entry THEN user sees "Entry not found" error`
- Edge: `AC-001.3: WHEN user archives already archived entry THEN no change occurs (idempotent)`

**Bad Examples (avoid these)**:
- ❌ `WHEN user archives entry THEN system SHALL mark as archived in database`
- ❌ `WHEN user unarchives entry THEN system SHALL remove archive flag`
- ❌ `WHEN migration runs THEN system SHALL add archived_at column`

### Step 3: MECE Review

Before requesting approval, perform MECE check:

1. Review all requirements for completeness
2. Identify any missing error scenarios
3. Check for requirement overlaps
4. Ensure edge cases are covered

Present findings:
```
## MECE Analysis

✓ Covered scenarios: [count]
⚠ Potential gaps: [list if any]
⚠ Possible overlaps: [list if any]

The requirements appear to be [MECE/not fully MECE].
```

### Step 4: Request User Approval

Present generated requirements and ask:

```
Requirements generation complete. Please review the requirements document.

Key points:
- Total requirements: [count]
- Normal behavior cases: [count]
- Error/unwanted behavior cases: [count]
- Edge cases: [count]

Do you approve these requirements?
- If yes: I will save to vault and update approval status
- If no: Please provide feedback for revision
```

### Step 5: Handle User Response

**If approved**:

1. Save requirements to vault
2. Update metadata in vault:
   - Phase: requirements-approved
   - Approvals > Requirements > Generated: true
   - Approvals > Requirements > Approved: true
3. Proceed to Output Format section

**If revision needed**:

1. Update requirements based on feedback (keep in memory)
2. Return to Step 3 (MECE Review)

**Continue iterating until approval**

---

## Output Format

After requirements are approved:

1. Display confirmation: "Requirements approved ✓"
2. Show updated vault keys:
   - Requirements document saved
   - Metadata updated with approval status
3. Present next step:
   ```
   You can now proceed to design phase:
   /spec:design {feature-name}
   ```
