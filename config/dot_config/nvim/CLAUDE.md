# Neovim configuration guide

Framework-free Neovim configuration. "Framework-free" means it depends on no
Neovim distribution or configuration framework (LazyVim, LunarVim, etc.).
Individual focused plugins are in scope; a distribution's opinionated bundle is
not.

## Workflow assumption

Neovim is opened **on demand** for review, navigation, and small edits, inside
an agent-driven workflow — it is not a long-running, editor-centric IDE. This
shapes what belongs here: fast review and light editing are first-class, while
persistent-IDE capabilities (in-editor test running, in-editor debugging) are
out of scope and run outside the editor. When considering a feature, ask
whether it earns its place in an on-demand review/edit tool.

## Plugin ownership: `vim.pack` + `lz.n`

- Remote plugins are installed with Neovim's built-in `vim.pack`; lazy-loading
  is owned by `lz.n`. There is no plugin-manager framework (`lazy.nvim` etc.).
- `lz.n` owns load timing. `init.lua` registers plugins without sourcing them
  eagerly, and `lz.n` triggers `run` on demand. Do not force a plugin to load
  during `init` unless it genuinely must.
- Plugin revisions are pinned in `nvim-pack-lock.json`; keep it in sync with the
  declared plugin specs.
- Local/first-party specs load through `lua/lib/plugin_loader.lua`; remote specs
  live under `lua/plugins/`.
- Warm no-file startup targets **~70ms**. Prefer lazy triggers (filetype,
  keymap, event, `colorscheme`) over eager loads. The custom `LazyFile` event in
  `init.lua` (grouping `BufReadPost` / `BufNewFile` / `BufWritePre`) and the
  `DeferredUIEnter` autocmd gate deferred work.

## Tool provisioning: Nix owns binaries

Nix owns every LSP, formatter, linter, and language runtime binary; there is no
in-editor package manager. Neovim only configures and invokes tools it finds on
its process `PATH`. LSP config carries no install responsibility, and there are
no `ensure_installed` package lists.

### Shared editor-scoped catalog

`nix/home/editor-language-tools.nix` is the single source of truth for common
language tooling, shared between Neovim and Zed. Tools are grouped by language
and role (`lsp` / `formatter` / `linter` / `runtime`); editors select languages
and receive a deduplicated package set.

- The catalog bin directory is **appended** to the inherited `PATH` (see the
  `--suffix PATH` wrapper in `nix/home/neovim.nix`), so a project devShell /
  direnv executable always wins over the common editor fallback.
- These tools are **not** on the global user `PATH`. They exist only in the
  editor's process environment.
- Common languages currently in the catalog: Nix, Lua, Go, Rust, shell,
  Markdown, JSON, YAML, TOML, Docker. Add a language by extending
  `languageTools` and `commonLanguages`, not by hardcoding packages in an
  editor's own list.

### Project-local languages (Python / TypeScript / JavaScript)

Pyright, Ruff, vtsls, Biome, Deno, and the language runtimes are deliberately
**absent** from the shared catalog. Each project that wants them declares them
in its Nix devShell and activates it through direnv; Neovim is launched from
that shell and inherits the binaries.

```nix
# flake.nix (excerpt)
devShells.default = pkgs.mkShell {
  packages = [pkgs.pyright pkgs.ruff pkgs.vtsls pkgs.biome];
};
```

```sh
# .envrc
use flake
```

LSP is enabled with `vim.lsp.enable` **only when the executable is visible**.
When a tool is missing, the buffer degrades to Treesitter syntax-only display
and saving is never broken. There is no dynamic direnv reload inside a running
session — the environment is fixed at launch.

"Project-local" applies to LSP / formatter / linter / runtime **executables**,
not to Treesitter parser/query assets (see below).

### Neovim-side wiring

Nix guarantees only that a binary is on `PATH`. How it is configured, invoked,
and bound to keys is the Neovim side's job, split across three files. The
configuration is deliberately **agnostic to whether a binary exists**: gating
makes a missing tool degrade quietly instead of erroring, so the same config
runs both in a fully-tooled project and in a bare Nix environment.

- **LSP — `lua/plugins/lspconfig.lua`.** `vim.lsp.config(server, {settings=…})`
  holds per-server settings; `vim.lsp.enable(server)` activates it. No install
  responsibility, no `ensure_installed`. Enablement is two-tier: common catalog
  servers (`nixd`, `lua_ls`, `gopls`, `yamlls`, `taplo`, `marksman`, …) are
  enabled unconditionally because the catalog guarantees them on `PATH`;
  project-local servers (`biome`, `vtsls`, `pyright`, `ruff`, `denols`,
  `docker_language_server`, …) are enabled only under
  `vim.fn.executable(...) == 1`. An `LspAttach` autocmd wires keymaps, inlay
  hints, and codelens at attach time.
- **Formatter — `lua/plugins/conform.lua`.** `formatters_by_ft` maps filetype to
  formatter; format-on-save runs on `BufWritePre` (suppressible via
  `vim.g`/`vim.b.autoformat`). Project-local formatters set `require_cwd = true`,
  and `notify_no_formatters = false` keeps a missing formatter from aborting
  `:write`.
- **Linter — `lua/plugins/nvim-lint.lua`.** `linters_by_ft` maps filetype to
  linter (`shellcheck`, `golangcilint`, `hadolint`, `markdownlint-cli2`, …), run
  debounced on `BufWritePost` / `BufReadPost` / `InsertLeave`.

Save ordering is intentional: Conform formats on `BufWritePre`, then nvim-lint
lints on `BufWritePost`, so the linter always sees the formatted buffer.

## Treesitter: built-in APIs + Nix parser/query assets

Highlighting and selection are built on Neovim's built-in Treesitter APIs, not
the `nvim-treesitter` runtime plugin. Parser/query assets ship declaratively in
the Neovim Nix closure (`nix/home/neovim.nix`); they are never on `PATH` and
never installed by a project devShell.

Grammars are grouped by intent in `nix/home/neovim.nix`:

- **common** — languages that also get full editor tooling from the catalog.
- **syntaxOnly** — review-only languages (Python, TS/JS, C/C++, SQL, Zig,
  HTML/CSS, …): parsers ship here for highlighting, but their LSP/formatter/
  linter stay project-local.
- **editor** — runtime/support grammars (`vim`, `vimdoc`, `query`, `diff`, git
  filetypes, …).

Incremental syntax-node selection lives in `lua/lib/treesitter_select.lua`,
built on the same built-in APIs.

## `lua/lib/` module conventions

- Plugin-independent standalone utilities live under `lua/lib/`.
- Reference them uniformly as `require("lib.<module>")`.
- Dependencies on a plugin framework's internals (`lazy.core.*`, `lazyvim.*`,
  etc.) are forbidden.
- Dependencies on a specific plugin's API (e.g. `tokyonight.colors`,
  `lualine.component`) are allowed, on the premise that the module is used only
  after that plugin has loaded.

## Built-in plugin guards

`init.lua` disables only the built-in runtime plugins with a clear replacement
overlap, and sets the loaded guards at the very top before options or plugin
registration:

- `netrw` / `netrwPlugin` → Yazi
- `matchit` / `matchparen` → vim-matchup

Disable a built-in only when a plugin demonstrably replaces it, not preemptively.
