---
description: Initialize steering documents for persistent project knowledge
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, mcp__vault
---

# Steering Initialization

Create foundational steering documents in vault to establish consistent project standards and conventions.

## Task: Generate Steering Documents

**SCOPE**: This command ONLY generates steering documents. It does not:

- Create specifications
- Modify any code
- Change project configuration

### Step 1: Analyze Project

Examine the current project to understand:

- Technology stack and architecture
- Project structure and organization patterns
- Product purpose and features

**CRITICAL**:

- Document ONLY facts that can be verified from the codebase or information directly provided by the user
- If anything is unclear or ambiguous, ASK THE USER - never make assumptions
- Do not guess or infer information that isn't explicitly evident
- Better to ask multiple questions than to document incorrect assumptions

### Step 2: Generate Steering Documents

Create three foundational documents:

**1. Product Overview** (save to `steering/product`):

- Product description and purpose
- Core features and capabilities
- Target use cases and users
- Key value propositions

**2. Technology Stack** (save to `steering/tech`):

- Architecture overview
- Frontend/Backend technologies
- Development environment and tools
- Common commands and configurations

**3. Project Structure** (save to `steering/structure`):

- Directory organization
- Code patterns and conventions
- File naming standards
- Architectural principles

### Step 3: Request User Approval

Present generated steering documents and ask:

```
Steering documents generated. Please review the following:
- Product Overview
- Technology Stack
- Project Structure

Do you approve these documents?
- If yes: I will save to vault
- If no: Please provide corrections or additional information
```

### Step 4: Handle User Response

**If approved**:

1. Save documents to vault using `mcp__vault__vault_set`:
   - Key: `steering/product`
   - Key: `steering/tech`
   - Key: `steering/structure`
2. Proceed to Output Format section

**If corrections needed**:

1. Update documents based on feedback
2. Return to Step 3

**Continue iterating until approval**

---

## Output Format

After generation:

1. Display summary of discovered project characteristics
2. Confirm vault keys created:
   - `steering/product` - Product overview
   - `steering/tech` - Technology stack
   - `steering/structure` - Project structure
3. Note: "Steering documents created. These will guide future spec generation."
