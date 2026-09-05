# managed-skills

`managed-skills` is the declarative policy layer for Agent Skills in this
dotfiles repository. It reads shared and machine-local YAML declarations,
translates them into non-interactive invocations of the
[`skills`](https://github.com/vercel-labs/skills) CLI, and records which
installations it owns.

Use this command for all skill installation and removal managed by this
repository. Do not edit generated agent skill directories directly.

## Responsibilities

The system is split into two layers:

- The upstream `skills` CLI discovers skills in a source and writes or removes
  files for each supported agent.
- `managed-skills` validates repository policy, selects sources and skills,
  invokes the upstream CLI, and maintains an ownership manifest.

Home Manager installs both commands, wraps `managed-skills` so that `skills` is
always on `PATH`, and links the shared configuration to
`~/.config/skills/skills.yaml`. Home Manager does not install the declared
skills during activation; synchronization is an explicit `managed-skills`
operation.

## Configuration files

`managed-skills` combines two files:

| File | Ownership | Purpose |
|---|---|---|
| `~/.config/skills/skills.yaml` | This repository | Shared remote sources, packages, global installations, and default agents |
| `~/.config/skills/local.yaml` | Machine-local and untracked | Local repository paths and project-specific installation targets |

The shared file is sourced from
[`config/dot_config/skills/skills.yaml`](../../../../config/dot_config/skills/skills.yaml).
Start a local file from
[`config/dot_config/skills/local.example.yaml`](../../../../config/dot_config/skills/local.example.yaml).

The current shared policy references the machine-local `my-agent-skills`
source. Consequently, this repository requires `local.yaml` to define that
source before any command that loads declarations can succeed.

### Configuration model

Declarations have three layers:

1. A **source** names a remote URL or a machine-local repository root.
2. A **package** selects one or more skills from a source.
3. An **install** places a package globally or in one project for a set of
   agents.

```yaml
defaults:
  agents:
    - claude-code
    - codex
    - opencode

sources:
  vercel-skills:
    url: https://github.com/vercel-labs/skills

packages:
  vercel-skills:
    source: vercel-skills
    skills: ["*"]

installs:
  - package: vercel-skills
    target: global
```

Shared and local `sources` and `packages` are merged by name. A name may appear
in only one file; shadowing is rejected.

### Sources

A source contains exactly one of these fields:

- `url`: a remote source accepted by the upstream `skills` CLI. Remote sources
  belong in the shared file.
- `path`: an existing absolute directory on the current machine. Local paths
  belong in `local.yaml`; `~` and relative paths are rejected.

### Packages

A package requires `source` and may select content with the following fields:

- `skills: [name, ...]` selects explicit skill names.
- `skills: ["*"]` selects every discovered skill.
- `exclude: [name, ...]` selects every discovered skill except the named
  entries.
- `paths: [relative/path, ...]` divides a local source into one or more install
  units. Each path must remain below the source root.

`skills` and `exclude` are mutually exclusive. `paths` is valid only for local
sources. An explicit skill list cannot be applied to multiple paths because it
would be ambiguous which path owns each name.

For wildcard or exclusion selection, local skills are discovered by finding
`SKILL.md` files and reading their frontmatter `name`. Remote skills are
discovered through `skills add SOURCE --list`.

### Installs

An install requires a package and target:

- `target: global` belongs in the shared configuration.
- An absolute project directory belongs in `local.yaml`.
- `agents` optionally overrides `defaults.agents` for one install.

Duplicate package-and-target pairs are rejected.

## Commands

```sh
managed-skills install
managed-skills uninstall
managed-skills status
```

All commands accept scope filters:

```sh
managed-skills install --global
managed-skills install --local
```

They also accept repeatable package filters:

```sh
managed-skills install --package vercel-skills
managed-skills install --package wtm --package llm-wiki
```

An unknown package fails before mutation.

### Install

`install` validates and materializes the selected declarations, checks for
managed name collisions, and invokes `skills add` once per install unit.

```sh
managed-skills install
managed-skills install --package vercel-skills --verbose
managed-skills install --dry-run
```

An ordinary install is additive. Removing a skill or package from YAML does not
remove a previously installed entry.

Each successful install unit is written to the manifest immediately. If a later
unit fails, the manifest still describes the successful work from the partial
run.

### Reset

Use reset when declarations should replace all selected state owned by this
manager:

```sh
managed-skills install --reset
managed-skills install --reset --global --package vercel-skills
managed-skills install --reset --dry-run
```

Before removing anything, reset discovers all selected wildcard sources and
verifies explicit skill names. It also checks managed name collisions against
entries that will be retained. Only after those checks pass does it remove the
selected manifest entries and reinstall the current declarations.

Reset refuses to remove tracked project-local entries if `local.yaml` is
missing. This prevents machine-local targets from being removed without their
current declarations being available.

Reset is not transactional. If installation fails after removal, the manifest
records the completed operations, but the selected state may remain partially
installed. Fix the underlying error and run reset again to converge.

### Uninstall

`uninstall` removes only entries owned in the manifest:

```sh
managed-skills uninstall
managed-skills uninstall --package vercel-skills
managed-skills uninstall --local --dry-run
```

It can operate from the manifest after declarations have changed. Package
filtering may load the configuration to attach package names to manifests
written by older versions.

### Status

```sh
managed-skills status
managed-skills status --package vercel-skills
```

Status reports declared install units and tracked manifest entries by scope. It
does not inspect installed files, compare remote revisions, or detect drift from
manual changes.

## Ownership manifest

State is stored at:

```text
~/.local/state/skills/manifest.json
```

Each entry identifies one skill installed for one agent and destination, along
with its source, origin, and package. The file is written through a temporary
file and atomically replaced.

Before installation, `managed-skills` rejects a skill name already owned by a
different source in the same global or project scope. The manifest tracks only
this manager's work; it does not establish ownership of manually installed
skills.

Do not delete the manifest merely to fix an installation problem. Losing it
prevents `managed-skills` from knowing which existing entries it is allowed to
remove.

## Common workflows

### Bootstrap a machine

1. Copy `config/dot_config/skills/local.example.yaml` to
   `~/.config/skills/local.yaml`.
2. Replace example paths with existing absolute paths for that machine.
3. Apply the Home Manager configuration.
4. Preview with `managed-skills install --dry-run`.
5. Run `managed-skills install`.

### Add a shared remote package

1. Add its URL under `sources` in the shared YAML.
2. Add a package selecting explicit skills, all skills, or all but an exclusion
   list.
3. Add a global install for the package.
4. Preview only that package with `--package NAME --dry-run`.
5. Install it. Use `--reset` if the package replaces previously managed state.

### Change the default agent set

Update `defaults.agents`, then use `install --reset`. A normal additive install
adds the new agent entries but intentionally retains manifest-owned entries for
agents removed from the declaration.

### Remove a package

Run `managed-skills uninstall --package NAME` while the package is still named
in the manifest. Then remove its install, package, and unused source declaration
from YAML.

## Failure behavior and limitations

- YAML structure, unknown keys, invalid paths, duplicate definitions, missing
  references, and managed name collisions fail before installation.
- Mutating upstream commands are non-interactive and always pass `--yes`.
- Remote wildcard discovery parses the human-readable output of
  `skills add --list`. An upstream output-format change may require updating
  `LISTED_SKILL` and its tests.
- The Nix lock pins the version of the upstream CLI delivered by
  `llm-agents.nix`, but source URLs in YAML are not pinned to repository commits.
  Re-running install may therefore consume newer source content.
- Remote discovery and installation are separate upstream calls. A source that
  changes between those calls can produce a result different from the list that
  was materialized for the manifest.

## Development

The package uses Python 3.11 or newer, PyYAML, type annotations, a `src/` layout,
pytest, and ruff.

From this directory:

```sh
uv run --with pytest --with ruff ruff check src tests
uv run --with pytest pytest
```

The Nix package also runs ruff, pytest, and an import check during its build; do
not disable those checks to work around a failure.

The test suite covers shared/local configuration merging, path validation,
wildcard and exclusion selection, package filters, collision detection,
manifest updates, reset preflight behavior, and removal across agents that share
one canonical skill directory.
