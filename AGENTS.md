# dotfiles Development Guide

## Nix Patterns

### wrapProgram Pattern

Bundle runtime dependencies with a package using `symlinkJoin` + `makeWrapper`:

```nix
{pkgs, ...}: {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "neovim-with-runtimes";
      paths = [pkgs.neovim];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/nvim \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.nodejs
          pkgs.python3
        ]}
      '';
      meta.mainProgram = "nvim";
    })
  ];
}
```

Used in: `neovim.nix`, `claude-code.nix`

### OS-Conditional Activation

Enable settings only on specific platforms:

```nix
{pkgs, lib, ...}: {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # macOS-only settings
  };
}
```

Used in: `nix/home/darwin/`

## Placement Guidelines

### darwin vs home-manager

| Criterion | nix/darwin | nix/home |
|-----------|------------|----------|
| Requires sudo | Yes | No |
| Scope | System-wide | Per-user |
| Update frequency | Low (system settings) | High (tools, dotfiles) |

**Rule of thumb**: If it needs sudo or is system-wide, use darwin. Otherwise use home-manager.

**Note**: darwin and home-manager are not integrated. Changes require their respective commands (see README.md).

### homebrew.nix vs brew-nix.nix

| Use | homebrew.nix | brew-nix.nix |
|-----|--------------|--------------|
| Primary | Fallback | Preferred |
| When | Hash missing, unstable, not in brew-nix | Available and stable |

**Rule of thumb**: Try brew-nix first for reproducibility. Fall back to homebrew when necessary.

### files.nix Symlinks

Current state: Most dotfiles in `config/` are symlinked via `files.nix`.

Future direction:
- **Symlink**: Frequently edited files (immediate feedback needed)
- **Direct management**: Stable configs that rarely change
