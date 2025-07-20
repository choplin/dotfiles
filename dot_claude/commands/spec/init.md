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

### 1. Analyze Project Description

From the provided description ($ARGUMENTS), extract:

- Project purpose and goals
- Key features and functionality
- Target users or use cases
- Technical requirements or constraints
- Any specific implementation details mentioned

### 2. Generate Feature Name

Based on the analysis, create a concise, descriptive feature name that captures the essence of the project.

### 3. Initialize Metadata in Vault

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

$ARGUMENTS

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
