# nvim-new

LazyVim から lz.n + vim.pack ベースへの再構築プロジェクト。詳細は `.claude/dev-workflow/epic/lazyvim-migration/epic.md` を参照。

## Conventions

### lib/ モジュール

- プラグイン依存のないスタンドアロンユーティリティは `lua/lib/` 配下に配置する
- 参照は `require("lib.<module>")` 形式で統一する
- `lazy.core.*` / `lazyvim.*` への依存は禁止
- プラグイン API（例: `tokyonight.colors`, `lualine.component`）への依存は許容される（該当プラグインがロードされた後のみ使用されることが前提）
