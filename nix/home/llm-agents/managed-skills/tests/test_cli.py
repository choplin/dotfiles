from __future__ import annotations

import json
from collections.abc import Sequence
from pathlib import Path

import pytest

from managed_skills.cli import CommandRunner, load_install_units, run


class FakeRunner(CommandRunner):
    def __init__(self, list_output: str = "") -> None:
        self.calls: list[tuple[list[str], str | None]] = []
        self.list_output = list_output

    def run(self, argv: Sequence[str], cwd: str | None = None) -> str:
        self.calls.append((list(argv), cwd))
        if "--list" in argv:
            return self.list_output
        return ""


def write_skill(root: Path, name: str) -> None:
    directory = root / name
    directory.mkdir(parents=True)
    (directory / "SKILL.md").write_text(f"---\nname: {name}\ndescription: Test\n---\n")


def write_config(path: Path, body: str) -> None:
    path.write_text(body)


def base_files(tmp_path: Path) -> tuple[Path, Path, Path, Path, Path]:
    repository = tmp_path / "catalog"
    group = repository / "skills/group"
    write_skill(group, "one")
    write_skill(group, "two")
    project = tmp_path / "project"
    project.mkdir()
    shared = tmp_path / "skills.yaml"
    local = tmp_path / "local.yaml"
    state = tmp_path / "state/manifest.json"
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [claude-code, codex]
global:
  - name: personal
    repository: personal
    paths: [skills/group]
""",
    )
    write_config(
        local,
        f"""\
repositories:
  personal:
    path: {repository}
projects:
  - path: {project}
    installs:
      - name: remote
        url: https://example.test/skills.git
        skills: [review]
        agents: [opencode]
""",
    )
    return shared, local, state, repository, project


def cli_args(shared: Path, local: Path, state: Path, *command: str) -> list[str]:
    return [
        "--config",
        str(shared),
        "--local-config",
        str(local),
        "--state",
        str(state),
        *command,
    ]


def test_loads_shared_and_local_config_with_agent_override(tmp_path: Path) -> None:
    shared, local, _, _, project = base_files(tmp_path)

    units = load_install_units(shared, local)

    assert len(units) == 2
    assert units[0].package == "personal"
    assert units[0].agents == ("claude-code", "codex")
    assert units[0].origin == "personal:skills/group"
    assert units[1].agents == ("opencode",)
    assert units[1].project == str(project)


def test_rejects_relative_machine_local_paths(tmp_path: Path) -> None:
    shared, local, _, _, _ = base_files(tmp_path)
    write_config(local, "repositories:\n  personal:\n    path: ~/catalog\n")

    with pytest.raises(Exception, match="must be absolute"):
        load_install_units(shared, local)


def test_install_tracks_exact_local_skill_names(
    tmp_path: Path, capsys: pytest.CaptureFixture[str]
) -> None:
    shared, local, state, _, _ = base_files(tmp_path)
    runner = FakeRunner()

    result = run(cli_args(shared, local, state, "install", "--global"), runner)

    assert result == 0
    add_call = runner.calls[0][0]
    assert add_call[:3] == ["skills", "add", add_call[2]]
    assert add_call[3:7] == ["--skill", "one", "two", "--agent"]
    manifest = json.loads(state.read_text())
    assert len(manifest["installations"]) == 4
    assert {entry["skill"] for entry in manifest["installations"]} == {"one", "two"}
    assert {entry["package"] for entry in manifest["installations"]} == {"personal"}
    captured = capsys.readouterr()
    assert captured.out == ""
    assert (
        "INSTALL  global · personal · 2 skills → claude-code, codex"
        in captured.err
    )
    assert "skills add" not in captured.err
    assert "DONE     installed 1 source, 2 skills, 4 agent installations" in captured.err
    assert "         - one" not in captured.err


def test_install_excludes_named_skills_from_wildcard(tmp_path: Path) -> None:
    shared, local, state, _, _ = base_files(tmp_path)
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [codex]
global:
  - name: personal
    repository: personal
    paths: [skills/group]
    exclude: [one]
""",
    )
    runner = FakeRunner()

    result = run(cli_args(shared, local, state, "install", "--global"), runner)

    assert result == 0
    assert runner.calls[0][0][3:5] == ["--skill", "two"]
    manifest = json.loads(state.read_text())
    assert {entry["skill"] for entry in manifest["installations"]} == {"two"}


def test_install_rejects_unknown_excluded_skill(tmp_path: Path) -> None:
    shared, local, state, _, _ = base_files(tmp_path)
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [codex]
global:
  - name: personal
    repository: personal
    paths: [skills/group]
    exclude: [missing]
""",
    )
    runner = FakeRunner()

    result = run(cli_args(shared, local, state, "install", "--global"), runner)

    assert result == 1
    assert runner.calls == []
    assert not state.exists()


def test_verbose_install_lists_individual_skills(
    tmp_path: Path, capsys: pytest.CaptureFixture[str]
) -> None:
    shared, local, state, _, _ = base_files(tmp_path)

    result = run(
        cli_args(
            shared,
            local,
            state,
            "install",
            "--global",
            "--dry-run",
            "--verbose",
        ),
        FakeRunner(),
    )

    assert result == 0
    captured = capsys.readouterr()
    assert captured.out == ""
    assert "PREVIEW  install · global · personal · 2 skills" in captured.err
    assert "\n         - one\n         - two\n" in captured.err


def test_ordinary_install_does_not_prune_old_manifest_entries(tmp_path: Path) -> None:
    shared, local, state, _, _ = base_files(tmp_path)
    state.parent.mkdir()
    state.write_text(
        json.dumps(
            {
                "version": 1,
                "installations": [
                    {
                        "scope": "global",
                        "project": None,
                        "agent": "codex",
                        "skill": "old-skill",
                        "source": "https://old.test/skills.git",
                        "origin": "https://old.test/skills.git",
                    }
                ],
            }
        )
    )

    result = run(cli_args(shared, local, state, "install", "--global"), FakeRunner())

    assert result == 0
    names = {entry["skill"] for entry in json.loads(state.read_text())["installations"]}
    assert names == {"old-skill", "one", "two"}


def test_uninstall_uses_manifest_without_loading_config(
    tmp_path: Path, capsys: pytest.CaptureFixture[str]
) -> None:
    missing_shared = tmp_path / "missing.yaml"
    missing_local = tmp_path / "missing-local.yaml"
    state = tmp_path / "state/manifest.json"
    state.parent.mkdir()
    state.write_text(
        json.dumps(
            {
                "version": 1,
                "installations": [
                    {
                        "scope": "global",
                        "project": None,
                        "agent": "codex",
                        "skill": "owned-skill",
                        "source": "https://example.test/skills.git",
                        "origin": "https://example.test/skills.git",
                    }
                ],
            }
        )
    )
    runner = FakeRunner()

    result = run(
        cli_args(missing_shared, missing_local, state, "uninstall", "--global"), runner
    )

    assert result == 0
    assert runner.calls == [
        (["skills", "remove", "owned-skill", "--agent", "codex", "--global", "--yes"], None)
    ]
    assert json.loads(state.read_text())["installations"] == []
    captured = capsys.readouterr()
    assert captured.out == ""
    assert "REMOVE   global · 1 skill → codex" in captured.err
    assert "skills remove" not in captured.err
    assert "DONE     removed 1 agent-skill entry" in captured.err


def test_reset_preflights_sources_before_uninstall(tmp_path: Path) -> None:
    shared, local, state, _, _ = base_files(tmp_path)
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [codex]
global:
  - name: missing
    repository: missing
    paths: [skills/group]
""",
    )
    state.parent.mkdir()
    state.write_text(
        json.dumps(
            {
                "version": 1,
                "installations": [
                    {
                        "scope": "global",
                        "project": None,
                        "agent": "codex",
                        "skill": "owned-skill",
                        "source": "old",
                        "origin": "old",
                    }
                ],
            }
        )
    )
    runner = FakeRunner()

    result = run(cli_args(shared, local, state, "install", "--reset", "--global"), runner)

    assert result == 1
    assert runner.calls == []
    assert json.loads(state.read_text())["installations"][0]["skill"] == "owned-skill"


def test_reset_verifies_explicit_remote_skill_before_uninstall(tmp_path: Path) -> None:
    shared = tmp_path / "skills.yaml"
    local = tmp_path / "local.yaml"
    state = tmp_path / "state/manifest.json"
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [codex]
global:
  - name: remote
    url: https://example.test/skills.git
    skills: [missing-skill]
""",
    )
    state.parent.mkdir()
    state.write_text(
        json.dumps(
            {
                "version": 1,
                "installations": [
                    {
                        "scope": "global",
                        "project": None,
                        "agent": "codex",
                        "skill": "owned-skill",
                        "source": "old",
                        "origin": "old",
                    }
                ],
            }
        )
    )
    runner = FakeRunner("│    another-skill\n")

    result = run(cli_args(shared, local, state, "install", "--reset", "--global"), runner)

    assert result == 1
    assert runner.calls == [
        (["skills", "add", "https://example.test/skills.git", "--list"], None)
    ]
    assert json.loads(state.read_text())["installations"][0]["skill"] == "owned-skill"


def test_reset_refuses_missing_local_config_with_tracked_projects(tmp_path: Path) -> None:
    shared = tmp_path / "skills.yaml"
    local = tmp_path / "missing-local.yaml"
    state = tmp_path / "state/manifest.json"
    project = tmp_path / "project"
    project.mkdir()
    write_config(shared, "version: 1\ndefaults:\n  agents: [codex]\n")
    state.parent.mkdir()
    state.write_text(
        json.dumps(
            {
                "version": 1,
                "installations": [
                    {
                        "scope": "project",
                        "project": str(project),
                        "agent": "codex",
                        "skill": "owned-skill",
                        "source": "old",
                        "origin": "old",
                    }
                ],
            }
        )
    )
    runner = FakeRunner()

    result = run(cli_args(shared, local, state, "install", "--reset", "--projects"), runner)

    assert result == 1
    assert runner.calls == []
    assert json.loads(state.read_text())["installations"][0]["skill"] == "owned-skill"


def test_remote_listing_is_parsed_before_install(tmp_path: Path) -> None:
    shared = tmp_path / "skills.yaml"
    local = tmp_path / "local.yaml"
    state = tmp_path / "manifest.json"
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [codex]
global:
  - name: remote
    url: https://example.test/skills.git
""",
    )
    runner = FakeRunner("│\n│    remote-one\n│\n│      A description\n")

    result = run(cli_args(shared, local, state, "install", "--global"), runner)

    assert result == 0
    assert runner.calls[0][0][-1] == "--list"
    assert "remote-one" in runner.calls[1][0]


def test_install_filters_repeatable_packages(tmp_path: Path) -> None:
    shared = tmp_path / "skills.yaml"
    local = tmp_path / "local.yaml"
    state = tmp_path / "manifest.json"
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [codex]
global:
  - name: first
    url: https://example.test/first.git
    skills: [one]
  - name: second
    url: https://example.test/second.git
    skills: [two]
  - name: third
    url: https://example.test/third.git
    skills: [three]
""",
    )
    runner = FakeRunner()

    result = run(
        cli_args(
            shared,
            local,
            state,
            "install",
            "--global",
            "--package",
            "first",
            "--package",
            "third",
        ),
        runner,
    )

    assert result == 0
    assert len(runner.calls) == 2
    assert runner.calls[0][0][2] == "https://example.test/first.git"
    assert runner.calls[1][0][2] == "https://example.test/third.git"
    manifest = json.loads(state.read_text())
    assert {entry["package"] for entry in manifest["installations"]} == {"first", "third"}


def test_install_rejects_unknown_package_before_mutation(tmp_path: Path) -> None:
    shared, local, state, _, _ = base_files(tmp_path)
    runner = FakeRunner()

    result = run(
        cli_args(
            shared,
            local,
            state,
            "install",
            "--global",
            "--package",
            "missing",
        ),
        runner,
    )

    assert result == 1
    assert runner.calls == []
    assert not state.exists()


def test_reset_only_removes_selected_package(tmp_path: Path) -> None:
    shared = tmp_path / "skills.yaml"
    local = tmp_path / "local.yaml"
    state = tmp_path / "state/manifest.json"
    write_config(
        shared,
        """\
version: 1
defaults:
  agents: [codex]
global:
  - name: first
    url: https://example.test/first.git
    skills: [one]
  - name: second
    url: https://example.test/second.git
    skills: [two]
""",
    )
    state.parent.mkdir()
    state.write_text(
        json.dumps(
            {
                "version": 1,
                "installations": [
                    {
                        "scope": "global",
                        "project": None,
                        "agent": "codex",
                        "skill": "one",
                        "source": "https://example.test/first.git",
                        "origin": "https://example.test/first.git",
                        "package": "first",
                    },
                    {
                        "scope": "global",
                        "project": None,
                        "agent": "codex",
                        "skill": "two",
                        "source": "https://example.test/second.git",
                        "origin": "https://example.test/second.git",
                        "package": "second",
                    },
                ],
            }
        )
    )
    runner = FakeRunner("│    one\n│    two\n")

    result = run(
        cli_args(
            shared,
            local,
            state,
            "install",
            "--reset",
            "--global",
            "--package",
            "first",
        ),
        runner,
    )

    assert result == 0
    assert runner.calls[0][0] == [
        "skills",
        "add",
        "https://example.test/first.git",
        "--list",
    ]
    assert runner.calls[1][0][:3] == ["skills", "remove", "one"]
    assert runner.calls[2][0][0:3] == [
        "skills",
        "add",
        "https://example.test/first.git",
    ]
    manifest = json.loads(state.read_text())
    assert {(entry["package"], entry["skill"]) for entry in manifest["installations"]} == {
        ("first", "one"),
        ("second", "two"),
    }
