---
created: 2025-07-28
updated: 2025-07-28
---

# Spec Command Common Reference

This document contains common background knowledge and patterns used across all spec commands.

## Vault Structure

All specification data is stored in the vault with the following structure:

### Steering Documents

- `steering/structure` - Structure context and architectural guidelines
- `steering/tech` - Technical constraints and technology decisions
- `steering/product` - Product context and business requirements

### Specification Documents

Each feature specification is stored under `specs/{feature-name}/` with these keys:

- `specs/{feature-name}/metadata` - Specification metadata and approval status
- `specs/{feature-name}/requirements` - Approved requirements document
- `specs/{feature-name}/design` - Approved technical design document
- `specs/{feature-name}/tasks` - Approved implementation task list
- `specs/{feature-name}/work-log` - Implementation work log tracking progress and decisions

## Vault Operations

### Reading from Vault

Use `mcp__vault__vault_get` to retrieve documents:

Retrieve metadata from vault using `mcp__vault__vault_get` with key `specs/{feature-name}/metadata`

### Writing to Vault

Use `mcp__vault__vault_set` to save documents:

Save to vault using `mcp__vault__vault_set` with key `specs/{feature-name}/metadata` and the content

### Listing Specifications

Use `mcp__vault__vault_list` to find all specifications:

List all specifications using `mcp__vault__vault_list` and filter for keys starting with "specs/" and ending with "/metadata"

## Metadata Structure

The metadata document tracks the specification lifecycle:

```yaml
# Spec Metadata

## Basic Information
- Feature Name: {feature-name}
- Created: {timestamp}
- Updated: {timestamp}
- Language: japanese
- Phase: {current-phase}

## Project Description
[Detailed project description]

## Approvals
### Requirements
- Generated: {true/false}
- Approved: {true/false}

### Design
- Generated: {true/false}
- Approved: {true/false}

### Tasks
- Generated: {true/false}
- Approved: {true/false}

## Status
- Ready for Implementation: {true/false}

## Implementation
- Status: {in-progress/completed/partially-completed}
- Completed Date: {date}
- Test Coverage: X/Y requirements
- Quality Checks: {passed/passed with warnings/failed}

## Phase
- Current: {initialized/requirements-approved/design-approved/ready-for-implementation/completed}
```

## Specification Workflow

1. **Initialize** (`/spec:init`) - Create metadata and project description
2. **Requirements** (`/spec:requirements`) - Generate and approve requirements
3. **Design** (`/spec:design`) - Create technical design based on requirements
4. **Tasks** (`/spec:tasks`) - Break down implementation into tasks
5. **Implement** (`/spec:implement`) - Execute tasks (managed separately)
6. **Complete** (`/spec:complete`) - Finalize and verify implementation

## Common Patterns

### Checking Prerequisites

Always verify the current phase and approvals before proceeding:

```
1. Retrieve metadata from vault using `mcp__vault__vault_get` with key `specs/$ARGUMENTS/metadata`
2. Parse the metadata to check specific approvals:
   - requirements_approved: `.approvals.requirements.approved`
   - design_approved: `.approvals.design.approved`
```

### Updating Phase

After each major step, update the metadata phase:

```
1. Update the phase field in the metadata object (e.g., set phase to "design-approved")
2. Save the updated metadata back to vault using `mcp__vault__vault_set` with key `specs/$ARGUMENTS/metadata`
```

### Error Handling

- If steering documents are not found, they are optional for new projects
- If metadata is not found, the specification hasn't been initialized
- Always check prerequisites before proceeding to the next phase
