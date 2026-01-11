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

## Traditional Dotfiles

Located in `config/`, organized by tool:

- **Editors** - Neovim, Zed, Vim configurations
- **Shell** - zsh with modular setup (aliases, functions, key bindings, etc.)
- **Terminal** - Wezterm, Ghostty
- **Development** - Git, mise, and related tools
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
