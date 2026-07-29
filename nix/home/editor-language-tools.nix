# Shared editor-scoped language tool catalog.
#
# Tools are grouped by language and role (lsp / formatter / linter / runtime).
# Editors select languages, get a deduplicated package list, and inject the
# resulting bin directory onto the *end* of the inherited PATH so a
# project/devShell executable wins over the common fallback.
{pkgs, lib}: let
  roles = ["lsp" "formatter" "linter" "runtime"];

  # Common languages for on-demand review / light edit. Python and
  # TypeScript/JavaScript stay project-local and are intentionally absent.
  languageTools = {
    nix = {
      lsp = [pkgs.nixd];
      formatter = [pkgs.alejandra];
      linter = [];
      runtime = [];
    };

    lua = {
      lsp = [pkgs.lua-language-server];
      formatter = [pkgs.stylua];
      linter = [];
      runtime = [];
    };

    go = {
      lsp = [pkgs.gopls];
      formatter = [pkgs.gotools pkgs.gofumpt]; # goimports via gotools
      linter = [pkgs.golangci-lint];
      runtime = [pkgs.go];
    };

    rust = {
      lsp = [pkgs.rust-analyzer];
      formatter = [pkgs.rustfmt];
      linter = [pkgs.clippy];
      runtime = [pkgs.rustc pkgs.cargo];
    };

    shell = {
      lsp = [pkgs.bash-language-server];
      formatter = [pkgs.shfmt];
      linter = [pkgs.shellcheck];
      runtime = [];
    };

    markdown = {
      lsp = [pkgs.marksman];
      formatter = [pkgs.markdownlint-cli2];
      linter = [pkgs.markdownlint-cli2];
      runtime = [];
    };

    json = {
      lsp = [pkgs.vscode-langservers-extracted];
      formatter = [];
      linter = [];
      runtime = [];
    };

    yaml = {
      lsp = [pkgs.yaml-language-server];
      formatter = [];
      linter = [];
      runtime = [];
    };

    toml = {
      lsp = [pkgs.taplo];
      formatter = [pkgs.taplo];
      linter = [];
      runtime = [];
    };

    docker = {
      lsp = [pkgs.docker-language-server];
      formatter = [];
      linter = [pkgs.hadolint];
      runtime = [];
    };
  };

  commonLanguages = [
    "nix"
    "lua"
    "go"
    "rust"
    "shell"
    "markdown"
    "json"
    "yaml"
    "toml"
    "docker"
  ];

  packagesForLanguage = name: let
    group = languageTools.${name} or (throw "unknown language tool group: ${name}");
  in
    lib.concatMap (role: group.${role}) roles;

  # Select languages and drop duplicate derivations (e.g. taplo / markdownlint
  # listed under multiple roles).
  selectLanguageTools = languages:
    lib.unique (lib.concatMap packagesForLanguage languages);

  mkEditorToolsEnv = {
    name,
    languages ? commonLanguages,
    extraPackages ? [],
  }:
    pkgs.buildEnv {
      inherit name;
      paths = (selectLanguageTools languages) ++ extraPackages;
      pathsToLink = ["/bin"];
    };
in {
  inherit languageTools commonLanguages selectLanguageTools mkEditorToolsEnv;
}
