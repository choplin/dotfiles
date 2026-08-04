"""Install and remove Agent Skills described by shared and local YAML files."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
from collections import defaultdict
from collections.abc import Sequence
from dataclasses import asdict, dataclass, replace
from pathlib import Path
from typing import Any, Literal

import yaml

Scope = Literal["global", "project"]
ANSI_ESCAPE = re.compile(r"\x1b(?:[@-_][0-?]*[ -/]*[@-~]|\[[0-?]*[ -/]*[@-~])")
LISTED_SKILL = re.compile(r"^│\s{4}([a-z0-9][a-z0-9-]*)\s*$")
PACKAGE_NAME = re.compile(r"^[a-z0-9][a-z0-9-]*$")


class ManagedSkillsError(Exception):
    """A user-facing configuration or command error."""


@dataclass(frozen=True)
class InstallUnit:
    """One invocation of `skills add`."""

    package: str
    source: str
    origin: str
    scope: Scope
    project: str | None
    agents: tuple[str, ...]
    skills: tuple[str, ...] | None
    excluded_skills: tuple[str, ...]
    local_source: bool


@dataclass(frozen=True)
class ManifestEntry:
    """One skill owned by this manager for one destination and agent."""

    scope: Scope
    project: str | None
    agent: str
    skill: str
    source: str
    origin: str
    package: str | None = None


class CommandRunner:
    """Run the upstream skills CLI."""

    def run(self, argv: Sequence[str], cwd: str | None = None) -> str:
        """Run a command and return combined output, raising a concise error."""
        result = subprocess.run(
            argv,
            cwd=cwd,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        if result.returncode != 0:
            output = result.stdout.strip()
            detail = f"\n{output}" if output else ""
            message = f"skills CLI failed with exit code {result.returncode}{detail}"
            raise ManagedSkillsError(message)
        return result.stdout


def default_paths() -> tuple[Path, Path, Path]:
    """Return the shared config, local config, and manifest paths."""
    home = Path.home()
    config_home = Path(os.environ.get("XDG_CONFIG_HOME", home / ".config"))
    state_home = Path(os.environ.get("XDG_STATE_HOME", home / ".local/state"))
    return (
        config_home / "skills/skills.yaml",
        config_home / "skills/local.yaml",
        state_home / "skills/manifest.json",
    )


def load_yaml(path: Path, *, required: bool) -> dict[str, Any]:
    """Load one YAML mapping."""
    if not path.exists():
        if required:
            raise ManagedSkillsError(f"config file does not exist: {path}")
        return {}
    try:
        value = yaml.safe_load(path.read_text())
    except (OSError, yaml.YAMLError) as error:
        raise ManagedSkillsError(f"cannot read YAML {path}: {error}") from error
    if value is None:
        return {}
    if not isinstance(value, dict):
        raise ManagedSkillsError(f"YAML root must be a mapping: {path}")
    return value


def require_list(value: Any, label: str) -> list[Any]:
    """Validate a YAML list."""
    if not isinstance(value, list):
        raise ManagedSkillsError(f"{label} must be a list")
    return value


def string_list(value: Any, label: str, *, allow_star: bool = False) -> tuple[str, ...]:
    """Validate and deduplicate a non-empty list of strings."""
    items = require_list(value, label)
    if not items or any(not isinstance(item, str) or not item for item in items):
        raise ManagedSkillsError(f"{label} must contain non-empty strings")
    if not allow_star and "*" in items:
        raise ManagedSkillsError(f"{label} does not accept '*' ")
    return tuple(dict.fromkeys(items))


def absolute_directory(value: Any, label: str) -> Path:
    """Validate a machine-local absolute directory path."""
    if not isinstance(value, str) or not value:
        raise ManagedSkillsError(f"{label} must be a non-empty absolute path")
    path = Path(value)
    if not path.is_absolute():
        raise ManagedSkillsError(f"{label} must be absolute (do not use '~'): {value}")
    if not path.is_dir():
        raise ManagedSkillsError(f"{label} is not a directory: {value}")
    return path.resolve()


def parse_repositories(local: dict[str, Any]) -> dict[str, Path]:
    """Parse local repository alias bindings."""
    raw = local.get("repositories", {})
    if not isinstance(raw, dict):
        raise ManagedSkillsError("local repositories must be a mapping")
    repositories: dict[str, Path] = {}
    for name, settings in raw.items():
        if not isinstance(name, str) or not name:
            raise ManagedSkillsError("repository names must be non-empty strings")
        if not isinstance(settings, dict) or set(settings) != {"path"}:
            raise ManagedSkillsError(f"repositories.{name} must contain only 'path'")
        repositories[name] = absolute_directory(settings["path"], f"repositories.{name}.path")
    return repositories


def resolve_local_source(repository: Path, relative: str, label: str) -> Path:
    """Resolve a relative package path without allowing repository escape."""
    candidate = Path(relative)
    if candidate.is_absolute():
        raise ManagedSkillsError(f"{label} must be relative: {relative}")
    resolved = (repository / candidate).resolve()
    try:
        resolved.relative_to(repository)
    except ValueError as error:
        raise ManagedSkillsError(f"{label} escapes its repository: {relative}") from error
    if not resolved.is_dir():
        raise ManagedSkillsError(f"{label} is not a directory: {relative}")
    return resolved


def parse_install(
    raw: Any,
    *,
    label: str,
    scope: Scope,
    project: Path | None,
    repositories: dict[str, Path],
    default_agents: tuple[str, ...],
) -> list[InstallUnit]:
    """Expand one install declaration into upstream CLI invocations."""
    if not isinstance(raw, dict):
        raise ManagedSkillsError(f"{label} must be a mapping")
    allowed = {"name", "url", "repository", "paths", "skills", "exclude", "agents"}
    unknown = set(raw) - allowed
    if unknown:
        raise ManagedSkillsError(f"{label} has unknown keys: {', '.join(sorted(unknown))}")
    source_keys = [key for key in ("url", "repository") if key in raw]
    if len(source_keys) != 1:
        raise ManagedSkillsError(f"{label} must contain exactly one of 'url' or 'repository'")
    package = raw.get("name")
    if not isinstance(package, str) or not PACKAGE_NAME.fullmatch(package):
        raise ManagedSkillsError(
            f"{label}.name must use lowercase letters, numbers, and hyphens"
        )

    agents = (
        string_list(raw["agents"], f"{label}.agents")
        if "agents" in raw
        else default_agents
    )
    if not agents:
        raise ManagedSkillsError(f"{label} needs agents or defaults.agents")

    raw_skills = raw.get("skills")
    skills = (
        string_list(raw_skills, f"{label}.skills", allow_star=True)
        if raw_skills is not None
        else None
    )
    if skills and "*" in skills:
        if skills != ("*",):
            raise ManagedSkillsError(f"{label}.skills '*' must be the only item")
        skills = None
    excluded_skills = (
        string_list(raw["exclude"], f"{label}.exclude") if "exclude" in raw else ()
    )
    if skills is not None and excluded_skills:
        raise ManagedSkillsError(f"{label} cannot combine 'skills' and 'exclude'")

    if "url" in raw:
        if "paths" in raw:
            raise ManagedSkillsError(f"{label}.paths is only valid with a local repository")
        url = raw["url"]
        if not isinstance(url, str) or not url:
            raise ManagedSkillsError(f"{label}.url must be a non-empty string")
        return [
            InstallUnit(
                package=package,
                source=url,
                origin=url,
                scope=scope,
                project=str(project) if project else None,
                agents=agents,
                skills=skills,
                excluded_skills=excluded_skills,
                local_source=False,
            )
        ]

    repository_name = raw["repository"]
    if not isinstance(repository_name, str) or not repository_name:
        raise ManagedSkillsError(f"{label}.repository must be a non-empty string")
    if repository_name not in repositories:
        raise ManagedSkillsError(f"{label} references unbound repository: {repository_name}")
    repository = repositories[repository_name]
    raw_paths = raw.get("paths", ["."])
    paths = string_list(raw_paths, f"{label}.paths")
    if len(paths) > 1 and skills is not None:
        raise ManagedSkillsError(f"{label} cannot apply an explicit skill list to multiple paths")

    units = []
    for index, relative in enumerate(paths):
        source = resolve_local_source(repository, relative, f"{label}.paths[{index}]")
        units.append(
            InstallUnit(
                package=package,
                source=str(source),
                origin=f"{repository_name}:{relative}",
                scope=scope,
                project=str(project) if project else None,
                agents=agents,
                skills=skills,
                excluded_skills=excluded_skills,
                local_source=True,
            )
        )
    return units


def load_install_units(shared_path: Path, local_path: Path) -> list[InstallUnit]:
    """Load and validate shared policy plus optional machine-local bindings."""
    shared = load_yaml(shared_path, required=True)
    local = load_yaml(local_path, required=False)
    if shared.get("version") != 1:
        raise ManagedSkillsError("skills.yaml version must be 1")

    defaults = shared.get("defaults", {})
    if not isinstance(defaults, dict) or set(defaults) - {"agents"}:
        raise ManagedSkillsError("defaults may contain only 'agents'")
    default_agents = (
        string_list(defaults["agents"], "defaults.agents") if "agents" in defaults else ()
    )
    repositories = parse_repositories(local)
    units: list[InstallUnit] = []

    for index, raw in enumerate(require_list(shared.get("global", []), "global")):
        units.extend(
            parse_install(
                raw,
                label=f"global[{index}]",
                scope="global",
                project=None,
                repositories=repositories,
                default_agents=default_agents,
            )
        )

    projects = require_list(local.get("projects", []), "local projects")
    for project_index, raw_project in enumerate(projects):
        label = f"projects[{project_index}]"
        if not isinstance(raw_project, dict) or set(raw_project) != {"path", "installs"}:
            raise ManagedSkillsError(f"{label} must contain exactly 'path' and 'installs'")
        project = absolute_directory(raw_project["path"], f"{label}.path")
        installs = require_list(raw_project["installs"], f"{label}.installs")
        for install_index, raw in enumerate(installs):
            units.extend(
                parse_install(
                    raw,
                    label=f"{label}.installs[{install_index}]",
                    scope="project",
                    project=project,
                    repositories=repositories,
                    default_agents=default_agents,
                )
            )
    return units


def discover_local_skills(source: Path) -> tuple[str, ...]:
    """Read skill names directly from a local package."""
    names: list[str] = []
    for skill_file in sorted(source.rglob("SKILL.md")):
        try:
            text = skill_file.read_text()
        except OSError as error:
            raise ManagedSkillsError(f"cannot read {skill_file}: {error}") from error
        if not text.startswith("---\n"):
            raise ManagedSkillsError(f"SKILL.md has no YAML frontmatter: {skill_file}")
        end = text.find("\n---", 4)
        if end == -1:
            raise ManagedSkillsError(f"SKILL.md has unterminated YAML frontmatter: {skill_file}")
        try:
            frontmatter = yaml.safe_load(text[4:end])
        except yaml.YAMLError as error:
            message = f"invalid SKILL.md frontmatter in {skill_file}: {error}"
            raise ManagedSkillsError(message) from error
        name = frontmatter.get("name") if isinstance(frontmatter, dict) else None
        if not isinstance(name, str) or not name:
            raise ManagedSkillsError(f"SKILL.md has no valid name: {skill_file}")
        names.append(name)
    if not names:
        raise ManagedSkillsError(f"no SKILL.md files found under {source}")
    return tuple(dict.fromkeys(names))


def parse_listed_skills(output: str, source: str) -> tuple[str, ...]:
    """Parse the human-readable output of `skills add --list`."""
    clean = ANSI_ESCAPE.sub("", output).replace("\r", "")
    names = [match.group(1) for line in clean.splitlines() if (match := LISTED_SKILL.match(line))]
    if not names:
        raise ManagedSkillsError(f"could not discover skill names from: {source}")
    return tuple(dict.fromkeys(names))


def available_skills(unit: InstallUnit, runner: CommandRunner) -> tuple[str, ...]:
    """Discover all skill names exposed by an install source."""
    if unit.local_source:
        return discover_local_skills(Path(unit.source))
    try:
        output = runner.run(["skills", "add", unit.source, "--list"], cwd=unit.project)
    except ManagedSkillsError as error:
        raise ManagedSkillsError(f"cannot inspect {unit.origin}: {error}") from error
    return parse_listed_skills(output, unit.source)


def materialize_units(
    units: Sequence[InstallUnit],
    runner: CommandRunner,
    *,
    verify_explicit: bool = False,
) -> list[InstallUnit]:
    """Resolve wildcard selections and optionally validate explicit names."""
    materialized = []
    for unit in units:
        if unit.skills is not None:
            if verify_explicit:
                available = set(available_skills(unit, runner))
                missing = [skill for skill in unit.skills if skill not in available]
                if missing:
                    raise ManagedSkillsError(
                        f"{unit.origin} does not contain skills: {', '.join(missing)}"
                    )
            materialized.append(unit)
            continue
        available = available_skills(unit, runner)
        available_set = set(available)
        missing_exclusions = [
            skill for skill in unit.excluded_skills if skill not in available_set
        ]
        if missing_exclusions:
            raise ManagedSkillsError(
                f"{unit.origin} does not contain excluded skills: "
                f"{', '.join(missing_exclusions)}"
            )
        excluded = set(unit.excluded_skills)
        skills = tuple(skill for skill in available if skill not in excluded)
        if not skills:
            raise ManagedSkillsError(f"{unit.origin} excludes every available skill")
        materialized.append(replace(unit, skills=skills))
    return materialized


def load_manifest(path: Path) -> list[ManifestEntry]:
    """Load the local ownership manifest."""
    if not path.exists():
        return []
    try:
        document = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError) as error:
        raise ManagedSkillsError(f"cannot read manifest {path}: {error}") from error
    if not isinstance(document, dict) or document.get("version") != 1:
        raise ManagedSkillsError(f"unsupported manifest format: {path}")
    raw_entries = document.get("installations")
    if not isinstance(raw_entries, list):
        raise ManagedSkillsError(f"manifest installations must be a list: {path}")
    entries = []
    try:
        for raw in raw_entries:
            entries.append(ManifestEntry(**raw))
    except (TypeError, KeyError) as error:
        raise ManagedSkillsError(f"invalid manifest entry in {path}: {error}") from error
    return entries


def write_manifest(path: Path, entries: Sequence[ManifestEntry]) -> None:
    """Atomically write the ownership manifest."""
    path.parent.mkdir(parents=True, exist_ok=True)
    document = {
        "version": 1,
        "installations": [asdict(entry) for entry in sorted(entries, key=manifest_sort_key)],
    }
    temporary_name: str | None = None
    try:
        with tempfile.NamedTemporaryFile(
            "w", dir=path.parent, prefix=f".{path.name}.", delete=False
        ) as temporary:
            temporary_name = temporary.name
            json.dump(document, temporary, indent=2)
            temporary.write("\n")
            temporary.flush()
            os.fsync(temporary.fileno())
        os.replace(temporary_name, path)
    finally:
        if temporary_name and os.path.exists(temporary_name):
            os.unlink(temporary_name)


def manifest_sort_key(entry: ManifestEntry) -> tuple[str, str, str, str, str, str]:
    """Return a deterministic manifest order."""
    return (
        entry.scope,
        entry.project or "",
        entry.package or "",
        entry.agent,
        entry.skill,
        entry.source,
    )


def scope_selected(scope: Scope, selected: str) -> bool:
    """Return whether a scope is included by the CLI filter."""
    return selected == "all" or selected == scope or (selected == "projects" and scope == "project")


def requested_packages(args: argparse.Namespace) -> tuple[str, ...]:
    """Return deduplicated package filters in command-line order."""
    return tuple(dict.fromkeys(args.packages))


def filter_units(units: Sequence[InstallUnit], packages: Sequence[str]) -> list[InstallUnit]:
    """Filter configured install units by package name."""
    if not packages:
        return list(units)
    available = {unit.package for unit in units}
    unknown = [package for package in packages if package not in available]
    if unknown:
        raise ManagedSkillsError(f"unknown package: {', '.join(unknown)}")
    selected = set(packages)
    return [unit for unit in units if unit.package in selected]


def attach_manifest_packages(
    entries: Sequence[ManifestEntry], units: Sequence[InstallUnit]
) -> list[ManifestEntry]:
    """Attach package names to manifests created before package filtering existed."""
    names = {
        (unit.scope, unit.project, unit.source): unit.package
        for unit in units
    }
    return [
        replace(
            entry,
            package=entry.package
            or names.get((entry.scope, entry.project, entry.source)),
        )
        for entry in entries
    ]


def filter_entries(
    entries: Sequence[ManifestEntry],
    packages: Sequence[str],
    *,
    known_packages: Sequence[str] = (),
) -> list[ManifestEntry]:
    """Filter manifest ownership entries by package name."""
    if not packages:
        return list(entries)
    available = {entry.package for entry in entries if entry.package} | set(known_packages)
    unknown = [package for package in packages if package not in available]
    if unknown:
        raise ManagedSkillsError(f"unknown package: {', '.join(unknown)}")
    selected = set(packages)
    return [entry for entry in entries if entry.package in selected]


def validate_ownership(units: Sequence[InstallUnit], existing: Sequence[ManifestEntry]) -> None:
    """Reject flat-name collisions between different sources."""
    owners: dict[tuple[Scope, str | None, str], tuple[str, str]] = {}
    for entry in existing:
        owners[(entry.scope, entry.project, entry.skill)] = (entry.source, entry.origin)
    for unit in units:
        assert unit.skills is not None
        for skill in unit.skills:
            key = (unit.scope, unit.project, skill)
            owner = owners.get(key)
            if owner and owner[0] != unit.source:
                message = (
                    f"skill collision for {skill}: {owner[1]} and {unit.origin} "
                    "target the same scope"
                )
                raise ManagedSkillsError(
                    message
                )
            owners[key] = (unit.source, unit.origin)


def install_command(unit: InstallUnit) -> list[str]:
    """Build one non-interactive upstream install command."""
    assert unit.skills is not None
    command = ["skills", "add", unit.source, "--skill", *unit.skills, "--agent", *unit.agents]
    if unit.scope == "global":
        command.append("--global")
    command.append("--yes")
    return command


def report(message: str) -> None:
    """Write a human-readable run report without polluting stdout."""
    print(message, file=sys.stderr, flush=True)


def scope_label(scope: Scope, project: str | None) -> str:
    """Describe an installation destination without exposing CLI mechanics."""
    return "global" if scope == "global" else f"project:{project}"


def counted(count: int, singular: str, plural: str | None = None) -> str:
    """Render a count with a grammatically correct unit."""
    unit = singular if count == 1 else (plural or f"{singular}s")
    return f"{count} {unit}"


def report_install(unit: InstallUnit, *, dry_run: bool, verbose: bool) -> None:
    """Report one logical install operation."""
    assert unit.skills is not None
    marker = "PREVIEW" if dry_run else "INSTALL"
    action = "install · " if dry_run else ""
    agents = ", ".join(unit.agents)
    destination = scope_label(unit.scope, unit.project)
    report(
        f"{marker:<8} {action}{destination} · {unit.package} · "
        f"{counted(len(unit.skills), 'skill')} → {agents}"
    )
    if verbose:
        for skill in unit.skills:
            report(f"         - {skill}")


def install_units(
    units: Sequence[InstallUnit],
    manifest_path: Path,
    entries: list[ManifestEntry],
    runner: CommandRunner,
    *,
    dry_run: bool,
    verbose: bool,
) -> list[ManifestEntry]:
    """Install every unit and record successful ownership atoms."""
    current = list(entries)
    for unit in units:
        command = install_command(unit)
        report_install(unit, dry_run=dry_run, verbose=verbose)
        if dry_run:
            continue
        runner.run(command, cwd=unit.project)
        assert unit.skills is not None
        additions = {
            ManifestEntry(
                scope=unit.scope,
                project=unit.project,
                agent=agent,
                skill=skill,
                source=unit.source,
                origin=unit.origin,
                package=unit.package,
            )
            for agent in unit.agents
            for skill in unit.skills
        }
        addition_keys = {
            (entry.scope, entry.project, entry.agent, entry.skill) for entry in additions
        }
        current = [
            entry
            for entry in current
            if (entry.scope, entry.project, entry.agent, entry.skill) not in addition_keys
        ]
        current = sorted(set(current) | additions, key=manifest_sort_key)
        write_manifest(manifest_path, current)
    skill_count = sum(len(unit.skills or ()) for unit in units)
    agent_installations = sum(len(unit.skills or ()) * len(unit.agents) for unit in units)
    if not units:
        report("DONE     nothing to install")
    elif dry_run:
        report(
            f"DONE     previewed {counted(len(units), 'source')}, "
            f"{counted(skill_count, 'skill')}, "
            f"{counted(agent_installations, 'agent installation')}"
        )
    else:
        report(
            f"DONE     installed {counted(len(units), 'source')}, "
            f"{counted(skill_count, 'skill')}, "
            f"{counted(agent_installations, 'agent installation')}"
        )
    return current


def uninstall_entries(
    selected_entries: Sequence[ManifestEntry],
    manifest_path: Path,
    all_entries: list[ManifestEntry],
    runner: CommandRunner,
    *,
    dry_run: bool,
) -> list[ManifestEntry]:
    """Remove manifest-owned skills, retaining records for failed operations."""
    groups: dict[tuple[Scope, str | None, str], list[ManifestEntry]] = defaultdict(list)
    for entry in selected_entries:
        groups[(entry.scope, entry.project, entry.agent)].append(entry)

    current = list(all_entries)
    for (scope, project, agent), group in sorted(groups.items()):
        if project is not None and not Path(project).is_dir():
            raise ManagedSkillsError(f"cannot uninstall from missing project directory: {project}")
        skills = sorted({entry.skill for entry in group})
        command = ["skills", "remove", *skills, "--agent", agent]
        if scope == "global":
            command.append("--global")
        command.append("--yes")
        marker = "PREVIEW" if dry_run else "REMOVE"
        action = "remove · " if dry_run else ""
        destination = scope_label(scope, project)
        report(f"{marker:<8} {action}{destination} · {counted(len(group), 'skill')} → {agent}")
        if dry_run:
            continue
        runner.run(command, cwd=project)
        removed = set(group)
        current = [entry for entry in current if entry not in removed]
        write_manifest(manifest_path, current)
    if not selected_entries:
        report("DONE     nothing to remove")
    elif dry_run:
        report(
            "DONE     previewed removal of "
            f"{counted(len(selected_entries), 'agent-skill entry', 'agent-skill entries')}"
        )
    else:
        report(
            "DONE     removed "
            f"{counted(len(selected_entries), 'agent-skill entry', 'agent-skill entries')}"
        )
    return current


def selected_scope(args: argparse.Namespace) -> str:
    """Translate mutually exclusive scope flags."""
    if args.global_only:
        return "global"
    if args.projects_only:
        return "projects"
    return "all"


def handle_install(
    args: argparse.Namespace,
    shared_path: Path,
    local_path: Path,
    manifest_path: Path,
    runner: CommandRunner,
) -> None:
    """Install the desired configuration, optionally resetting owned state first."""
    scope = selected_scope(args)
    packages = requested_packages(args)
    all_units = load_install_units(shared_path, local_path)
    scoped_units = [
        unit
        for unit in all_units
        if scope_selected(unit.scope, scope)
    ]
    units = filter_units(scoped_units, packages)
    entries = attach_manifest_packages(load_manifest(manifest_path), all_units)
    scoped_entries = [entry for entry in entries if scope_selected(entry.scope, scope)]
    reset_entries = filter_entries(
        scoped_entries,
        packages,
        known_packages=[unit.package for unit in scoped_units],
    )
    reset_entry_set = set(reset_entries)
    retained_entries = [entry for entry in entries if entry not in reset_entry_set]
    resetting_projects = args.reset and scope in {"all", "projects"}
    has_tracked_projects = any(entry.scope == "project" for entry in reset_entries)
    if resetting_projects and has_tracked_projects and not local_path.exists():
        raise ManagedSkillsError(
            f"refusing to reset tracked projects without local config: {local_path}"
        )
    if units:
        report(f"RESOLVE  inspecting {counted(len(units), 'install source')}")
    units = materialize_units(units, runner, verify_explicit=args.reset)
    validate_ownership(units, retained_entries if args.reset else entries)

    if args.reset:
        entries = uninstall_entries(
            reset_entries,
            manifest_path,
            entries,
            runner,
            dry_run=args.dry_run,
        )
    install_units(
        units,
        manifest_path,
        entries,
        runner,
        dry_run=args.dry_run,
        verbose=args.verbose,
    )


def handle_uninstall(
    args: argparse.Namespace,
    shared_path: Path,
    local_path: Path,
    manifest_path: Path,
    runner: CommandRunner,
) -> None:
    """Uninstall explicitly selected manifest-owned state."""
    scope = selected_scope(args)
    packages = requested_packages(args)
    entries = load_manifest(manifest_path)
    known_packages: list[str] = []
    manifest_names = {entry.package for entry in entries if entry.package}
    if packages and any(package not in manifest_names for package in packages):
        all_units = load_install_units(shared_path, local_path)
        entries = attach_manifest_packages(entries, all_units)
        known_packages = [
            unit.package for unit in all_units if scope_selected(unit.scope, scope)
        ]
    scoped_entries = [entry for entry in entries if scope_selected(entry.scope, scope)]
    selected = filter_entries(
        scoped_entries,
        packages,
        known_packages=known_packages,
    )
    uninstall_entries(selected, manifest_path, entries, runner, dry_run=args.dry_run)


def handle_status(
    args: argparse.Namespace,
    shared_path: Path,
    local_path: Path,
    manifest_path: Path,
) -> None:
    """Print a concise view of desired declarations and tracked state."""
    scope = selected_scope(args)
    packages = requested_packages(args)
    all_units = load_install_units(shared_path, local_path)
    scoped_units = [
        unit
        for unit in all_units
        if scope_selected(unit.scope, scope)
    ]
    units = filter_units(scoped_units, packages)
    all_entries = attach_manifest_packages(load_manifest(manifest_path), all_units)
    scoped_entries = [
        entry for entry in all_entries if scope_selected(entry.scope, scope)
    ]
    entries = filter_entries(
        scoped_entries,
        packages,
        known_packages=[unit.package for unit in scoped_units],
    )
    print(f"declared install units: {len(units)}")
    print(f"tracked agent-skill installations: {len(entries)}")
    for entry_scope in ("global", "project"):
        count = sum(entry.scope == entry_scope for entry in entries)
        print(f"  {entry_scope}: {count}")


def add_scope_arguments(parser: argparse.ArgumentParser) -> None:
    """Add the common mutually exclusive scope filters."""
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--global", dest="global_only", action="store_true")
    group.add_argument("--projects", dest="projects_only", action="store_true")


def add_package_arguments(parser: argparse.ArgumentParser) -> None:
    """Add the repeatable package filter."""
    parser.add_argument(
        "--package",
        dest="packages",
        action="append",
        default=[],
        metavar="NAME",
        help="limit the operation to a named package (repeatable)",
    )


def build_parser() -> argparse.ArgumentParser:
    """Build the command-line interface."""
    shared, local, state = default_paths()
    parser = argparse.ArgumentParser(prog="managed-skills")
    parser.add_argument("--config", type=Path, default=shared, help=argparse.SUPPRESS)
    parser.add_argument("--local-config", type=Path, default=local, help=argparse.SUPPRESS)
    parser.add_argument("--state", type=Path, default=state, help=argparse.SUPPRESS)
    subparsers = parser.add_subparsers(dest="command", required=True)

    install = subparsers.add_parser("install", help="install declared skills")
    add_scope_arguments(install)
    add_package_arguments(install)
    install.add_argument("--reset", action="store_true", help="remove managed skills first")
    install.add_argument("--dry-run", action="store_true", help="print without changing state")
    install.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="list individual skills being installed",
    )

    uninstall = subparsers.add_parser("uninstall", help="remove manifest-owned skills")
    add_scope_arguments(uninstall)
    add_package_arguments(uninstall)
    uninstall.add_argument("--dry-run", action="store_true", help="print without changing state")

    status = subparsers.add_parser("status", help="show declarations and tracked state")
    add_scope_arguments(status)
    add_package_arguments(status)
    return parser


def run(argv: Sequence[str] | None = None, runner: CommandRunner | None = None) -> int:
    """Run the CLI and return an exit status."""
    args = build_parser().parse_args(argv)
    command_runner = runner or CommandRunner()
    try:
        if args.command == "install":
            handle_install(args, args.config, args.local_config, args.state, command_runner)
        elif args.command == "uninstall":
            handle_uninstall(
                args,
                args.config,
                args.local_config,
                args.state,
                command_runner,
            )
        else:
            handle_status(args, args.config, args.local_config, args.state)
    except ManagedSkillsError as error:
        print(f"managed-skills: {error}", file=sys.stderr)
        return 1
    return 0


def main() -> None:
    """Console-script entry point."""
    raise SystemExit(run())


if __name__ == "__main__":
    main()
