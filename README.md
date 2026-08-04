# dotfiles

Personal configuration files managed with Nix Flakes and traditional dotfiles.

## Architecture

| Directory | Purpose |
|-----------|---------|
| `nix/` | Declarative system and home configuration via Nix |
| `config/` | Traditional dotfiles for various tools |
| `.claude/` | Claude Code settings |

## Nix Configuration

Entry point: `flake.nix`

### nix/darwin (system config, requires sudo)

macOS system-level settings, organized by function:

- **system.nix** - System preferences
- **hotkeys.nix** - Keyboard shortcuts
- **services.nix** - Background services
- **brew-nix.nix** - GUI apps via nix (preferred for reproducibility)
- **homebrew.nix** - Fallback for apps not available or unstable in brew-nix

### nix/home (user config, no sudo)

User-level settings, managed independently from nix-darwin:

- **Common settings at root, macOS-specific in darwin/**
- **CLI tools** - Environment-independent tools in packages
- **GUI apps with heavy config** - AeroSpace, SketchyBar live here to avoid frequent `darwin-rebuild`
- **files.nix** - Symlinks dotfiles from `config/` (transitional; ideally only frequently-edited files use symlinks)

### AI Agent CLIs (llm-agents)

AI coding agent CLIs are pulled from the [`llm-agents.nix`](https://github.com/numtide/llm-agents.nix) flake input (`github:numtide/llm-agents.nix`), which provides prebuilt, daily-updated packages for tools like `claude-code`, `codex`, `cursor-agent`, and `antigravity-cli`.

- **Where**: exposed to home-manager modules as the `llm-agents` arg (see `nix/flake-modules/home.nix`); consumed by modules under `nix/home/llm-agents/`.
- **No `follows`**: the input intentionally does **not** follow this repo's `nixpkgs`. Cache hits from `cache.numtide.com` require the exact `nixpkgs` upstream built against (notably `codex`, which is compiled from source). Adding `inputs.nixpkgs.follows = "nixpkgs"` would force local rebuilds.
- **Cache**: `flake.nix` registers `cache.numtide.com` as a substituter so these CLIs are fetched prebuilt instead of built locally.
- **Extra tools**: beyond the agent CLIs, `nix/home/llm-agents/default.nix` installs [`hunk`](https://github.com/modem-dev/hunk) (terminal diff viewer for agentic changesets), and `nix/home/llm-agents/skills.nix` installs [`skills`](https://github.com/vercel-labs/skills) (manage agent skills across AI coding agents).

### Managed Agent Skills

[`config/dot_config/skills/skills.yaml`](./config/dot_config/skills/skills.yaml)
declares remote sources, aliased local sources, and the user-global installation
policy shared across machines. Home Manager symlinks it to
`~/.config/skills/skills.yaml` and installs the `managed-skills` command.

Machine-specific repository and project paths belong in
`~/.config/skills/local.yaml`, which is deliberately not managed by this
repository. Start from
[`config/dot_config/skills/local.example.yaml`](./config/dot_config/skills/local.example.yaml)
and use absolute paths. A local repository is bound once by name; install entries
then select paths relative to that repository root. An install can use
`exclude` to omit named skills while selecting the rest of a source.

```sh
managed-skills install                 # Add/reinstall all declarations
managed-skills install --global        # Only user-global declarations
managed-skills install --projects      # Only project declarations
managed-skills install --package my-agent-skills  # Only one named package
managed-skills install --package my-agent-skills --verbose  # List each skill
managed-skills install --reset         # Remove managed entries, then reinstall
managed-skills uninstall               # Remove every manifest-owned entry
managed-skills status                  # Summarize declarations and tracked state
```

`install` is additive: removing an entry from YAML does not uninstall it.
Repeat `--package NAME` to select more than one named package. The same filter
works with `uninstall` and `status`. Add `--verbose` to `install` to list every
skill selected from each package.
`uninstall` reads the ownership manifest at
`~/.local/state/skills/manifest.json`, so it can remove past installations even
after their declaration has changed. Use the same scope flags with `uninstall`
or `install --reset`; add `--dry-run` to either mutating command to preview it.

## Traditional Dotfiles

Located in `config/`, organized by tool:

- **Editors** - Neovim, Zed, Vim configurations
- **Shell** - zsh with modular setup (aliases, functions, key bindings, etc.)
- **Terminal** - Wezterm, Ghostty
- **Development** - Git and related tools
- **macOS** - Karabiner, AeroSpace, SketchyBar, and other macOS utilities

## Usage

Initial setup:

```sh
nix flake update
```

Apply system configuration (macOS):

```sh
sudo darwin-rebuild switch --flake .
```

Apply home configuration:

```sh
home-manager switch --flake .
```
