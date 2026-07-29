# 🔌 Plugins

All plugins used in this Neovim configuration, organized by category.

---

## 🎨 UI / Appearance

- **tokyonight.nvim** — Color scheme (Tokyo Night moon variant)
- **lualine.nvim** — Status line
- **bufferline.nvim** — Buffer/tab bar
- **noice.nvim** — Enhanced messages, cmdline, popups
- **mini.icons** — File type icons
- **mini.hipatterns** — Inline color/pattern highlighting
- **snacks.nvim** — Dashboard, notifier, indent guides, statuscolumn, picker, and more

## 🔍 Navigation / Search

- **flash.nvim** — Fast cursor motion with labels
- **grug-far.nvim** — Search and replace
- **yazi.nvim** — File manager integration
- **outline.nvim** — Document symbols sidebar
- **marks.nvim** — Mark indicators in sign column

## ✏️ Editing

- **mini.pairs** — Auto bracket/quote pairing
- **mini.surround** — Surround text operations
- **mini.ai** — Extended text objects
- **substitute.nvim** — Substitute with register contents
- **dial.nvim** — Extended increment/decrement
- **align.nvim** — Text alignment
- **yanky.nvim** — Yank history with cycling
- **vim-table-mode** — Table editing
- **ts-comments.nvim** — Treesitter-aware commenting
- **nvim-ts-autotag** — Auto-close HTML/JSX tags

## 🧠 LSP / Completion / Diagnostics

- **nvim-lspconfig** — LSP client configuration (25+ languages)
- **blink.cmp** — Completion engine
- **conform.nvim** — Code formatter
- **nvim-lint** — Async linter integration
- **trouble.nvim** — Diagnostics and references UI
- **inc-rename.nvim** — LSP rename with preview
- **neoconf.nvim** — Per-project LSP config
- **lazydev.nvim** — Lua development environment
- **neogen** — Documentation generator

## 🌳 Treesitter

- **nvim-treesitter** — Syntax highlighting and parsing
- **nvim-treesitter-context** — Sticky context header
- **nvim-context-vt** — Scope context as virtual text
- **nvim-ufo** — Treesitter/LSP-based folding
- **vim-matchup** — Enhanced matching

## 🔧 Git

- **gitsigns.nvim** — Sign column indicators and hunk operations
- **diffview.nvim** — Diff viewer and file history
- **git-conflict.nvim** — Merge conflict resolution
- **octo.nvim** — GitHub issues and PRs
- **committia.vim** — Commit message editing
- **auto-git-diff** — Diff in interactive rebase
- **linediff.vim** — Diff arbitrary line ranges

## 🐛 Test

- **neotest** — Test runner framework

## 🗄️ Language-specific

- **rustaceanvim** — Rust (rust-analyzer)
- **clangd_extensions.nvim** — C/C++ (clangd)
- **crates.nvim** — Rust Cargo.toml
- **zig.vim** — Zig
- **moonbit.nvim** — MoonBit (local)

Intentionally unsupported (not a migration gap): Scala, Java, and Kotlin —
Metals, JDTLS, kotlin-language-server, and JVM-only editor tools are removed.

## 📦 Misc

- **which-key.nvim** — Keybinding discovery
- **persistence.nvim** — Session management
- **todo-comments.nvim** — TODO/FIXME highlighting
- **sniprun** — Run code snippets
- **nvim-bqf** — Enhanced quickfix list
- **nvim-config-local** — Per-project config loader
- **scope.nvim** — Tab-scoped buffers
- **render-markdown.nvim** — In-buffer markdown rendering
- **markdown-preview.nvim** — Browser markdown preview
- **nvim-jqx** — JSON viewer with jq
- **vim-dadbod + UI** — Database client
- **sidekick.nvim** — AI assistant panel
- **code-review.nvim** — In-editor code review (local)
