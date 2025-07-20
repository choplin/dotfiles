---
description: Create technical design for a specification
allowed-tools: Bash, Read, Write, Edit, MultiEdit, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Technical Design

**Feature**: $ARGUMENTS

## Prerequisites Check

**CRITICAL**: Verify requirements are approved before proceeding.

Check metadata at `specs/$ARGUMENTS/metadata` for:

- **Approvals > Requirements > Approved**: must be true
- **Phase**: should be "requirements-approved"

**STOP** if requirements are not approved. Direct user to complete requirements approval first.

## Task: Create Technical Design

**SCOPE**: This command ONLY generates technical design. It does not:

- Modify requirements
- Generate implementation tasks
- Write any code
- Create any other documentation

Create comprehensive design document based on approved requirements:

### Step 1: Gather Context

Retrieve from vault:

- Approved requirements from `specs/$ARGUMENTS/requirements`
- Spec metadata from `specs/$ARGUMENTS/metadata` (for language)
- Steering documents if available (`steering/structure`, `steering/tech`, `steering/product`)

### Step 2: Generate Design Document

Create a comprehensive technical design document that includes:

**Context & Goals** (when appropriate):

- Overview and background
- Goals and non-goals
- Success criteria

**Technical Design**:

- How to implement the approved requirements
- Architecture and system design
- API and data model specifications
- Security, performance, and testing considerations

Format as a standard design doc with appropriate sections.

**IMPORTANT**: Use diagrams extensively - include Mermaid, PlantUML, or ASCII art diagrams for:

- System architecture
- Component relationships
- Data flow
- Sequence diagrams for key interactions
- State diagrams where applicable

### Step 3: Request User Approval

Present generated design and ask:

```
Technical design complete. Please review the design document.

Do you approve this design?
- If yes: I will save to vault and update approval status
- If no: Please provide feedback for revision
```

### Step 4: Handle User Response

**If approved**:

1. Save design to `specs/$ARGUMENTS/design`
2. Update metadata at `specs/$ARGUMENTS/metadata`:
   - Phase: design-approved
   - Approvals > Design > Generated: true
   - Approvals > Design > Approved: true
3. Proceed to Output Format section

**If revision needed**:

1. Update design based on feedback (keep in memory)
2. Return to Step 3

**Continue iterating until approval**

---

## Output Format

After design is approved:

1. Display confirmation: "Technical design approved ✓"
2. Show updated vault keys:
   - `specs/$ARGUMENTS/design` - Approved design
   - `specs/$ARGUMENTS/metadata` - Updated with approval status
3. Present next step:
   ```
   You can now proceed to task planning:
   /spec:tasks {feature-name}
   ```
