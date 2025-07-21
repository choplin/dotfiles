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

1. **Retrieve from vault**:
   - Approved requirements from `specs/$ARGUMENTS/requirements`
   - Spec metadata from `specs/$ARGUMENTS/metadata` (for language)
   - Steering documents if available (`steering/structure`, `steering/tech`, `steering/product`)

2. **Analyze existing implementation** (CRITICAL):
   - Search for related existing code and features
   - Identify current patterns and architectures
   - Document dependencies and integration points
   - Note any constraints from existing system

### Step 2: Generate Design Document

Create a comprehensive technical design document that includes:

**Context & Goals**:

- Overview and background
- Goals and non-goals
- Success criteria
- **Existing System Analysis**:
  - Current implementation overview
  - Integration points with existing features
  - Backward compatibility requirements

**Technical Design**:

- How to implement the approved requirements
  - Map design elements to specific requirements (REQ-001, REQ-002, etc.)
  - Ensure all requirements are addressed in the design
- Architecture and system design **aligned with existing patterns**
- API and data model specifications **compatible with current schemas**
- Security, performance, and testing considerations
- **Regression Prevention**:
  - List of existing features that must continue working
  - Potential impact areas
  - Mitigation strategies for identified risks

**Requirement Traceability**:
- Include a section showing which design components address which requirements
- Example: "The UserService handles REQ-001 (User Registration) and REQ-003 (Authentication)"

Format as a standard design doc with appropriate sections.

**Visual Representation Guidelines**:

1. **Prefer Markdown when possible**:
   - Tables for structured data (API endpoints, data models, configurations)
   - Lists for hierarchies and relationships
   - Code blocks for interfaces and examples
   - Blockquotes for important notes

2. **Use diagrams when Markdown is insufficient**:
   - Mermaid/PlantUML for complex flows and interactions:
     - System architecture with multiple components
     - Sequence diagrams for multi-step processes
     - State machines with transitions
     - Complex data flows
   - ASCII art for simple diagrams when appropriate

3. **Examples**:
   - API endpoints → Markdown table
   - Simple hierarchy → Markdown nested lists
   - Database schema → Markdown table
   - Complex component interactions → Mermaid diagram
   - Multi-service flow → Sequence diagram

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
