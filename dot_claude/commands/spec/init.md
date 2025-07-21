---
description: Initialize a new specification with detailed project description and requirements
allowed-tools: Bash, Read, Write, Glob, mcp__vault__vault_set, mcp__vault__vault_get, mcp__vault__vault_list
---

# Spec Initialization

**Project Description**: $ARGUMENTS

## Steering Context Validation

### Check Steering Documents from Vault

Check for steering documents in vault with keys:

- `steering/structure` - Structure context
- `steering/tech` - Technical constraints
- `steering/product` - Product context

Use `mcp__vault__vault_get` to retrieve each steering document if available.

**FLEXIBILITY**: For new features or empty projects, steering documents are recommended but not required. If steering keys are not found in vault, you may proceed directly to spec generation phase.

## Task: Initialize Specification Structure

**SCOPE**: This command initializes the specification structure in vault based on the detailed project description provided.

### 1. Interpret Project Description

From the provided input ($ARGUMENTS), interpret and expand:

- Project purpose and goals
- Key features and functionality
- Target users or use cases
- Technical requirements or constraints
- Any specific implementation details mentioned

**Note**: User inputs are often brief. Expand and clarify based on context and steering documents.

### 2. Present Interpretation for Approval

Before proceeding, present your interpretation:

```
## Project Interpretation

Based on your input: "$ARGUMENTS"

I understand this as:
- **Purpose**: [expanded description of what the project aims to achieve]
- **Key Features**: [list of interpreted features]
- **Target Users**: [who will use this]
- **Technical Scope**: [inferred technical requirements]

**Proposed Feature Name**: {suggested-feature-name}

Is this interpretation correct? (yes/no/modify)
```

Wait for user approval or clarification before proceeding.

### 3. Generate Feature Name

Based on the approved interpretation, finalize the feature name.

### 4. Initialize Metadata in Vault

Save initial metadata to vault key `specs/{generated-feature-name}/metadata`:

```markdown
# Spec Metadata

## Basic Information

- **Feature Name**: {generated-feature-name}
- **Created**: {current_timestamp}
- **Updated**: {current_timestamp}
- **Language**: japanese
- **Phase**: initialized

## Project Description

[The approved interpretation from Step 2]

## Approvals

### Requirements

- Generated: false
- Approved: false

### Design

- Generated: false
- Approved: false

### Tasks

- Generated: false
- Approved: false

## Status

- Ready for Implementation: false
```

Use `mcp__vault__vault_set` to save this metadata.

## Output Format

After initialization, provide:

1. Generated feature name and rationale
2. Brief project summary
3. Created vault key: `specs/{generated-feature-name}/metadata`
4. Request user approval with the following message:

```
Spec initialization complete. Would you like to proceed to the next step?

Next command:
/spec:requirements {feature-name}
```
