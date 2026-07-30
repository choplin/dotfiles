{pkgs, lib, ...}: let
  editorTools = import ./editor-language-tools.nix {inherit pkgs lib;};

  ts = pkgs.vimPlugins.nvim-treesitter;

  # Parsers/queries ship in the Neovim Nix closure — never on PATH and never
  # installed by project devShells. Common languages get full editor tooling
  # elsewhere; syntax-only / review-only languages get highlighting here only.
  treesitterLanguages = {
    common = [
      "lua"
      "luadoc"
      "go"
      "gomod"
      "gosum"
      "gowork"
      "gotmpl"
      "rust"
      "nix"
      "bash"
      "markdown"
      "markdown_inline"
      "json"
      "yaml"
      "toml"
      "dockerfile"
    ];

    # Syntax-only / review-only: LSP and other tools stay project-local.
    syntaxOnly = [
      "python"
      "javascript"
      "jsdoc"
      "typescript"
      "tsx"
      "c"
      "cpp"
      "sql"
      "svelte"
      "zig"
      "html"
      "css"
      "graphql"
    ];

    # Editor/runtime support grammars.
    editor = [
      "vim"
      "vimdoc"
      "query"
      "regex"
      "comment"
      "diff"
      "git_config"
      "git_rebase"
      "gitattributes"
      "gitcommit"
      "gitignore"
      "make"
      "cmake"
      "ini"
      "xml"
    ];
  };

  treesitterLanguageNames =
    treesitterLanguages.common
    ++ treesitterLanguages.syntaxOnly
    ++ treesitterLanguages.editor;

  treesitterRuntime = lib.concatMap (
    name: [
      ts.parsers.${name}
      ts.queries.${name}
    ]
  )
  treesitterLanguageNames;

  # MoonBit is not in nvim-treesitter's official grammar set; ship parser +
  # queries from moonbitlang/tree-sitter-moonbit. Toolchain stays project-local.
  moonbitTreesitter = pkgs.neovimUtils.grammarToPlugin (pkgs.tree-sitter.buildGrammar {
    language = "moonbit";
    version = "0.0.0+rev=5435c30";
    src = pkgs.fetchFromGitHub {
      owner = "moonbitlang";
      repo = "tree-sitter-moonbit";
      rev = "5435c307c6cf2ef0d508a99047b06f35a4308444";
      hash = "sha256-UUEjrF6uGwTtFGRjmjw75ky8eDwVwAHOHro48TAI+WM=";
    };
    meta.homepage = "https://github.com/moonbitlang/tree-sitter-moonbit";
  });

  # Shared common-language tools only. Treesitter parser/query assets are
  # owned by the Neovim packpath below, not by this PATH catalog.
  neovimTools = editorTools.mkEditorToolsEnv {
    name = "neovim-language-tools";
    languages = editorTools.commonLanguages;
    extraPackages = [];
  };

  # Built-in Treesitter APIs + declarative parser/query assets.
  # pkgs.neovim is neovim-unwrapped under the nightly overlay, so use
  # wrapNeovimUnstable rather than the older `neovim.override { configure… }`.
  neovimWithTreesitter = pkgs.wrapNeovimUnstable pkgs.neovim {
    plugins = treesitterRuntime ++ [moonbitTreesitter];
    wrapRc = false;
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;
    withPerl = false;
    wrapperArgs = [
      "--suffix"
      "PATH"
      ":"
      "${neovimTools}/bin"
    ];
  };
in {
  home.packages = [
    (neovimWithTreesitter.overrideAttrs (old: {
      meta = (old.meta or {}) // {mainProgram = "nvim";};
    }))
  ];
}
