---
description: Update steering documents based on recent project changes
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, mcp__vault
---

# Steering Update

Update existing steering documents in vault to reflect recent project changes.

## Task: Update Steering Documents

**SCOPE**: This command ONLY updates existing steering documents. It does not:

- Create new specifications
- Modify any code
- Change project configuration

### Step 1: Analyze Changes

Retrieve current steering documents from vault:

- `steering/product` - Product overview
- `steering/tech` - Technology stack
- `steering/structure` - Project structure

Analyze recent project changes to identify what needs updating.

**CRITICAL**:

- Document ONLY verifiable changes from the codebase or user input
- ASK THE USER about any unclear changes - never assume
- Focus on significant changes, not minor updates

### Step 2: Update Steering Documents

Based on identified changes, update the relevant documents:

**1. Product Overview** (`steering/product`):

- New or removed features
- Changed use cases or target audience
- Updated value propositions

**2. Technology Stack** (`steering/tech`):

- New dependencies or removed libraries
- Major version upgrades
- New development tools or configurations
- Changed commands or environment setup

**3. Project Structure** (`steering/structure`):

- New directories or reorganization
- Changed naming conventions
- Updated architectural patterns

Only update sections that have meaningful changes.

### Step 3: Request User Approval

Present updated steering documents and ask:

```
Steering documents updated based on recent changes. Please review:
- Product Overview (changes: [list changes])
- Technology Stack (changes: [list changes])
- Project Structure (changes: [list changes])

Do you approve these updates?
- If yes: I will save to vault
- If no: Please provide corrections
```

### Step 4: Handle User Response

**If approved**:

1. Save updated documents to vault:
   - `steering/product`
   - `steering/tech`
   - `steering/structure`
2. Proceed to Output Format section

**If corrections needed**:

1. Apply corrections
2. Return to Step 3

**Continue iterating until approval**

---

## Output Format

After updates are approved:

1. Display summary of changes made
2. Confirm vault keys updated
3. Note: "Steering documents updated to reflect current project state."
