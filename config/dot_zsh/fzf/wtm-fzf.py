#!/usr/bin/env python3
"""Enrichment and preview for fzf worktree selector (wtm integration)."""

import json
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone


def run(cmd, cwd=None, timeout=5):
    """Run a command and return stdout, or None on failure."""
    try:
        r = subprocess.run(
            cmd, capture_output=True, text=True, cwd=cwd, timeout=timeout
        )
        if r.returncode == 0:
            return r.stdout.strip()
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return None


def get_default_branch():
    """Detect the default branch (main/master)."""
    out = run(["git", "rev-parse", "--abbrev-ref", "origin/HEAD"])
    if out:
        return out.removeprefix("origin/")
    # Fallback: check if main or master exists
    for branch in ("main", "master"):
        if run(["git", "rev-parse", "--verify", f"refs/heads/{branch}"]) is not None:
            return branch
    return "main"


def get_worktrees():
    """Get worktree list from wtm."""
    out = run(["wtm", "list", "--format", "json"])
    if out is None:
        return []
    return json.loads(out)


def get_git_status(path, branch, default_branch):
    """Get ahead/behind count and dirty state for a worktree."""
    ahead, behind = 0, 0
    dirty = False

    if branch and branch != default_branch:
        out = run(
            ["git", "rev-list", "--left-right", "--count",
             f"{default_branch}...{branch}"]
        )
        if out:
            parts = out.split()
            if len(parts) == 2:
                behind, ahead = int(parts[0]), int(parts[1])

    out = run(["git", "-C", path, "status", "--porcelain"])
    if out is not None:
        dirty = len(out) > 0

    return {"ahead": ahead, "behind": behind, "dirty": dirty}


def get_pr_info(branch):
    """Get PR info for a branch via gh CLI."""
    out = run([
        "gh", "pr", "list",
        "--head", branch,
        "--state", "all",
        "--json", "number,state,isDraft,reviewDecision,statusCheckRollup,latestReviews",
        "--limit", "1",
    ])
    if out is None:
        return None
    prs = json.loads(out)
    if not prs:
        return None
    return prs[0]


def format_git_col(status, is_primary):
    """Format GIT column for list display."""
    if is_primary:
        return "-"
    a, b, d = status["ahead"], status["behind"], status["dirty"]
    parts = []
    if a > 0 or b > 0:
        parts.append(f"↑{a}↓{b}")
    if d:
        parts.append("●")
    return " ".join(parts) if parts else "clean"


def format_pr_col(pr):
    """Format PR column for list display."""
    if pr is None:
        return "-"
    num = pr.get("number", "?")
    state = pr.get("state", "").lower()
    is_draft = pr.get("isDraft", False)

    # State: nf-oct-git_pull_request variants
    if state == "merged":
        state_str = "\uf407 merged"   # nf-oct-git_merge
    elif state == "closed":
        state_str = "\uf408 closed"   # nf-oct-git_pull_request_closed
    elif is_draft:
        state_str = "\uf040 draft"    # nf-fa-pencil
    else:
        state_str = "\uf409 open"     # nf-oct-git_pull_request

    # Skip CI/review for merged/closed PRs
    if state in ("merged", "closed"):
        return f"#{num} {state_str}"

    # CI status
    checks = pr.get("statusCheckRollup", []) or []
    ci = ""
    if checks:
        all_pass = all(
            c.get("conclusion") == "SUCCESS" or c.get("status") == "COMPLETED"
            for c in checks
        )
        any_fail = any(c.get("conclusion") == "FAILURE" for c in checks)
        if any_fail:
            ci = " \uf00d"   # nf-fa-close
        elif all_pass:
            ci = " \uf00c"   # nf-fa-check
        else:
            ci = " \uf110"   # nf-fa-spinner

    # Review status
    review = pr.get("reviewDecision", "")
    rev = ""
    if review == "APPROVED":
        rev = " \uf164"       # nf-fa-thumbs_up
    elif review == "CHANGES_REQUESTED":
        rev = " \uf12a"       # nf-fa-exclamation
    elif any(r.get("state") == "COMMENTED" for r in (pr.get("latestReviews") or [])):
        rev = " \uf075"       # nf-fa-comment

    return f"#{num} {state_str}{ci}{rev}"


def format_relative_time(iso_str):
    """Format ISO timestamp as relative time."""
    try:
        dt = datetime.fromisoformat(iso_str.replace("Z", "+00:00"))
        now = datetime.now(timezone.utc)
        delta = now - dt
        days = delta.days
        if days == 0:
            hours = delta.seconds // 3600
            if hours == 0:
                return "just now"
            return f"{hours}h ago"
        if days < 30:
            return f"{days}d ago"
        return f"{days // 30}mo ago"
    except (ValueError, TypeError):
        return "?"


def cmd_enrich():
    """Enrich worktree list with git status and PR info."""
    worktrees = get_worktrees()
    if not worktrees:
        return

    default_branch = get_default_branch()

    # Collect results in parallel (git + gh)
    results = {}
    with ThreadPoolExecutor(max_workers=8) as pool:
        futures = {}
        for wt in worktrees:
            name = wt["name"]
            branch = wt.get("branch", "")
            path = wt.get("path", "")
            is_primary = branch == default_branch

            fut_git = pool.submit(get_git_status, path, branch, default_branch)
            fut_pr = pool.submit(get_pr_info, branch) if branch and not is_primary else None
            futures[name] = (fut_git, fut_pr, is_primary)

        for name, (fut_git, fut_pr, is_primary) in futures.items():
            git_status = fut_git.result(timeout=10)
            pr_info = fut_pr.result(timeout=10) if fut_pr else None
            results[name] = (git_status, pr_info, is_primary)

    # Build rows
    rows = []
    for wt in worktrees:
        name = wt["name"]
        branch = wt.get("branch", "")
        created = format_relative_time(wt.get("created", ""))
        git_status, pr_info, is_primary = results[name]
        git_col = format_git_col(git_status, is_primary)
        pr_col = format_pr_col(pr_info)
        rows.append((name, branch, git_col, pr_col, created))

    if not rows:
        return

    # Header + rows with aligned columns
    widths = [max(len(r[i]) for r in rows) for i in range(5)]
    widths[0] = max(widths[0], 4)  # NAME
    widths[1] = max(widths[1], 6)  # BRANCH
    widths[2] = max(widths[2], 3)  # GIT
    widths[3] = max(widths[3], 2)  # PR
    widths[4] = max(widths[4], 7)  # CREATED

    header = (
        f"{'NAME':<{widths[0]}}  "
        f"{'BRANCH':<{widths[1]}}  "
        f"{'GIT':<{widths[2]}}  "
        f"{'PR':<{widths[3]}}  "
        f"{'CREATED':<{widths[4]}}"
    )
    print(header)
    for row in rows:
        line = (
            f"{row[0]:<{widths[0]}}  "
            f"{row[1]:<{widths[1]}}  "
            f"{row[2]:<{widths[2]}}  "
            f"{row[3]:<{widths[3]}}  "
            f"{row[4]:<{widths[4]}}"
        )
        print(line)


def cmd_preview(name):
    """Show detailed preview for a worktree."""
    out = run(["wtm", "show", name, "--format", "json"])
    if out is None:
        print(f"Error: worktree '{name}' not found")
        return

    wt = json.loads(out)
    branch = wt.get("branch", "")
    path = wt.get("path", "")
    head = wt.get("head", "")[:7]
    default_branch = get_default_branch()
    is_primary = name == "(primary)" or branch == default_branch

    # Parallel fetch
    with ThreadPoolExecutor(max_workers=4) as pool:
        fut_git = pool.submit(get_git_status, path, branch, default_branch)
        fut_log = pool.submit(
            run, ["git", "-C", path, "log", "--oneline", "--format=%h %s (%cr)", "-10"]
        )
        fut_files = pool.submit(run, ["git", "-C", path, "status", "--short"])
        fut_pr = pool.submit(
            run,
            ["gh", "pr", "view", branch,
             "--json", "number,state,title,reviewDecision,statusCheckRollup,reviews,url"],
        ) if not is_primary else None

        git_status = fut_git.result(timeout=10)
        log_out = fut_log.result(timeout=10)
        files_out = fut_files.result(timeout=10)
        pr_out = fut_pr.result(timeout=10) if fut_pr else None

    # Basic info
    print(f"Branch:   {branch}")
    print(f"Path:     {path}")
    print(f"HEAD:     {head}")

    # Git status line
    if not is_primary:
        a, b = git_status["ahead"], git_status["behind"]
        parts = []
        if a > 0 or b > 0:
            parts.append(f"{a} ahead, {b} behind {default_branch}")
        else:
            parts.append(f"up to date with {default_branch}")
        if files_out:
            n = len(files_out.splitlines())
            parts.append(f"{n} modified file{'s' if n != 1 else ''}")
        print(f"Status:   {' | '.join(parts)}")

    # Recent commits
    if log_out:
        print(f"\n--- Recent Commits ---")
        for line in log_out.splitlines()[:10]:
            print(line)

    # Modified files
    if files_out:
        print(f"\n--- Modified Files ---")
        for line in files_out.splitlines():
            print(line)

    # PR info
    if pr_out:
        try:
            pr = json.loads(pr_out)
        except json.JSONDecodeError:
            return

        num = pr.get("number", "?")
        state = pr.get("state", "OPEN").lower()
        title = pr.get("title", "")
        url = pr.get("url", "")

        print(f"\n--- Pull Request #{num} ({state}) ---")
        print(f"Title:    {title}")

        # Review summary
        review_decision = pr.get("reviewDecision", "")
        if review_decision == "APPROVED":
            print("Review:   ✓ approved")
        elif review_decision == "CHANGES_REQUESTED":
            print("Review:   changes requested")
        elif review_decision == "REVIEW_REQUIRED":
            print("Review:   review required")

        # CI status
        checks = pr.get("statusCheckRollup", []) or []
        if checks:
            all_pass = all(
                c.get("conclusion") == "SUCCESS" or c.get("status") == "COMPLETED"
                for c in checks
            )
            any_fail = any(c.get("conclusion") == "FAILURE" for c in checks)
            if any_fail:
                print("CI:       ✗ some checks failed")
            elif all_pass:
                print("CI:       ✓ all checks passed")
            else:
                print("CI:       … checks in progress")

        if url:
            print(f"URL:      {url}")


def cmd_list():
    """Quick worktree list with placeholder columns (no external calls)."""
    worktrees = get_worktrees()
    if not worktrees:
        return

    rows = []
    for wt in worktrees:
        name = wt["name"]
        branch = wt.get("branch", "")
        created = format_relative_time(wt.get("created", ""))
        rows.append((name, branch, "…", "…", created))

    widths = [max(len(r[i]) for r in rows) for i in range(5)]
    widths[0] = max(widths[0], 4)
    widths[1] = max(widths[1], 6)
    widths[2] = max(widths[2], 3)
    widths[3] = max(widths[3], 2)
    widths[4] = max(widths[4], 7)

    header = (
        f"{'NAME':<{widths[0]}}  "
        f"{'BRANCH':<{widths[1]}}  "
        f"{'GIT':<{widths[2]}}  "
        f"{'PR':<{widths[3]}}  "
        f"{'CREATED':<{widths[4]}}"
    )
    print(header)
    for row in rows:
        line = (
            f"{row[0]:<{widths[0]}}  "
            f"{row[1]:<{widths[1]}}  "
            f"{row[2]:<{widths[2]}}  "
            f"{row[3]:<{widths[3]}}  "
            f"{row[4]:<{widths[4]}}"
        )
        print(line)


def main():
    if len(sys.argv) < 2:
        print("Usage: wtm-fzf.py <list|enrich|preview> [args...]", file=sys.stderr)
        sys.exit(1)

    cmd = sys.argv[1]
    if cmd == "list":
        cmd_list()
    elif cmd == "enrich":
        cmd_enrich()
    elif cmd == "preview":
        if len(sys.argv) < 3:
            print("Usage: wtm-fzf.py preview <name>", file=sys.stderr)
            sys.exit(1)
        cmd_preview(sys.argv[2])
    else:
        print(f"Unknown command: {cmd}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
