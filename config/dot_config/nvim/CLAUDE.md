# nvim-new

LazyVim から lz.n + vim.pack ベースへの再構築プロジェクト。詳細は `.claude/dev-workflow/epic/lazyvim-migration/epic.md` を参照。

## Conventions

### lib/ モジュール

- プラグイン依存のないスタンドアロンユーティリティは `lua/lib/` 配下に配置する
- 参照は `require("lib.<module>")` 形式で統一する
- `lazy.core.*` / `lazyvim.*` への依存は禁止
- プラグイン API（例: `tokyonight.colors`, `lualine.component`）への依存は許容される（該当プラグインがロードされた後のみ使用されることが前提）

### Project-local language tools (Python / TypeScript / JavaScript)

Pyright, Ruff, vtsls, Biome, Deno は共通 editor PATH カタログに入れない。
プロジェクトの devShell + direnv で供給し、その環境から Neovim を起動する。

```nix
# flake.nix (excerpt)
devShells.default = pkgs.mkShell {
  packages = [
    pkgs.pyright
    pkgs.ruff
    pkgs.vtsls
    pkgs.biome
  ];
};
```

```sh
# .envrc
use flake
```

LSP は実行ファイルが見えるときだけ `vim.lsp.enable` する。見つからない場合は
Treesitter の syntax-only 表示のみで、保存を壊さない。direnv の動的リロードはしない。
