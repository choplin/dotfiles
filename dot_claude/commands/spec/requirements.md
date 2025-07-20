---
description: Generate comprehensive requirements for a specification
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Requirements Generation

**Feature**: $ARGUMENTS

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

### Requirement 1

**User Story:** As a [user type], I want to [do something], so that I can [achieve some goal]

#### Acceptance Criteria

[Write acceptance criteria in EARS format]

### Requirement 2, 3, ...

[Continue with additional requirements following the same pattern]
```

**Requirements must be**:

- User-centric with clear user stories
- **TESTABLE** - Each EARS criterion must translate to specific test cases for TDD
- Aligned with steering context and system constraints

### Step 3: Request User Approval

Present generated requirements and ask:

```
Requirements generation complete. Please review the requirements document.

Do you approve these requirements?
- If yes: I will save to vault and update approval status
- If no: Please provide feedback for revision
```

### Step 4: Handle User Response

**If approved**:

1. Save requirements to `specs/$ARGUMENTS/requirements`
2. Update metadata at `specs/$ARGUMENTS/metadata`:
   - Phase: requirements-approved
   - Approvals > Requirements > Generated: true
   - Approvals > Requirements > Approved: true
3. Proceed to Output Format section

**If revision needed**:

1. Update requirements based on feedback (keep in memory)
2. Return to Step 3

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
