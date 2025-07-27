---
description: Generate comprehensive requirements for a specification
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Requirements Generation

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

- Spec metadata from `specs/$ARGUMENTS/metadata` (for language and project description)
- Steering documents if available (`steering/structure`, `steering/tech`, `steering/product`)

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
  - Normal behavior (what the system SHALL do)
  - Unwanted behavior (what the system SHALL NOT do or SHALL reject)
  - Edge cases and boundary conditions
- Aligned with steering context and system constraints

**EARS Format Guidelines**:
- Keep each criterion on a single line for clarity
- Use bullet points for list formatting
- Include mix of normal, error, and edge cases
- **Label Format**: `AC-XXX.Y` where XXX is requirement number, Y is criterion number
- Examples:
  - Normal: `AC-001.1: WHEN user provides valid email THEN system SHALL create account`
  - Error: `AC-001.2: WHEN user provides invalid email THEN system SHALL reject with error message`
  - Edge: `AC-001.3: WHEN user provides email at maximum length THEN system SHALL accept it`

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

1. Save requirements to `specs/$ARGUMENTS/requirements`
2. Update metadata at `specs/$ARGUMENTS/metadata`:
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
   - `specs/$ARGUMENTS/requirements` - Approved requirements
   - `specs/$ARGUMENTS/metadata` - Updated with approval status
3. Present next step:
   ```
   You can now proceed to design phase:
   /spec:design {feature-name}
   ```
