# dotfiles

Personal configuration files managed with Nix Flakes and traditional dotfiles.

## Architecture

| Directory | Purpose |
|-----------|---------|
| `nix/` | Declarative system and home configuration via Nix |
| `config/` | Traditional dotfiles for various tools |
| `.claude/` | Claude Code settings and custom skills |

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

- **Where**: exposed to home-manager modules as the `llm-agents` arg (see `nix/flake-modules/home.nix`); consumed in `nix/home/claude-code.nix`, `codex.nix`, `cursor-agent.nix`, `antigravity-cli.nix`, `hunk.nix`, `skills.nix`.
- **No `follows`**: the input intentionally does **not** follow this repo's `nixpkgs`. Cache hits from `cache.numtide.com` require the exact `nixpkgs` upstream built against (notably `codex`, which is compiled from source). Adding `inputs.nixpkgs.follows = "nixpkgs"` would force local rebuilds.
- **Cache**: `flake.nix` registers `cache.numtide.com` as a substituter so these CLIs are fetched prebuilt instead of built locally.
- **Extra tools**: beyond the agent CLIs, `hunk.nix` installs [`hunk`](https://github.com/modem-dev/hunk) (terminal diff viewer for agentic changesets) and `skills.nix` installs [`skills`](https://github.com/vercel-labs/skills) (manage agent skills across AI coding agents).

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
