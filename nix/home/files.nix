{
  config,
  rootDir,
  ...
}: let
  link = config.lib.file.mkOutOfStoreSymlink;
  configDir = "${rootDir}/config";
in {
  # ~/.config/* -> config/dot_config/*
  xdg.configFile = {
    "broot".source = link "${configDir}/dot_config/broot";
    "lazygit".source = link "${configDir}/dot_config/lazygit";
    "luacheck".source = link "${configDir}/dot_config/luacheck";
    "mise".source = link "${configDir}/dot_config/mise";
    "nvim".source = link "${configDir}/dot_config/nvim";
    "ripgrep".source = link "${configDir}/dot_config/ripgrep";
    "sheldon".source = link "${configDir}/dot_config/sheldon";
    "starship.toml".source = link "${configDir}/dot_config/starship.toml";
    "wezterm".source = link "${configDir}/dot_config/wezterm";
    "yazi".source = link "${configDir}/dot_config/yazi";
    "zsh".source = link "${configDir}/dot_config/zsh";
    "karabiner".source = link "${configDir}/dot_config/karabiner";
    "zed".source = link "${configDir}/dot_config/zed";
  };

  # ~/* -> config/dot_*
  home.file = {
    ".clang-format".source = link "${configDir}/dot_clang-format";
    # ~/.claude/* -> config/dot_claude/* (individual files to allow Claude to add its own)
    ".claude/CLAUDE.md".source = link "${configDir}/dot_claude/CLAUDE.md";
    ".claude/commands".source = link "${configDir}/dot_claude/commands";
    ".claude/docs".source = link "${configDir}/dot_claude/docs";
    ".claude/languages".source = link "${configDir}/dot_claude/languages";
    ".claude/references".source = link "${configDir}/dot_claude/references";
    ".claude/scripts".source = link "${configDir}/dot_claude/scripts";
    ".claude/settings.json".source = link "${configDir}/dot_claude/settings.json";
    ".direnvrc".source = link "${configDir}/dot_direnvrc";
    ".editorconfig".source = link "${configDir}/dot_editorconfig";
    ".git-scripts".source = link "${configDir}/dot_git-scripts";
    ".gitattributes".source = link "${configDir}/dot_gitattributes";
    ".gitconfig".source = link "${configDir}/dot_gitconfig";
    ".gitignore_global".source = link "${configDir}/dot_gitignore_global";
    ".ideavimrc".source = link "${configDir}/dot_ideavimrc";
    ".tigrc".source = link "${configDir}/dot_tigrc";
    ".tmux.conf".source = link "${configDir}/dot_tmux.conf";
    ".vimrc".source = link "${configDir}/dot_vimrc";
    ".zsh".source = link "${configDir}/dot_zsh";
    ".zshrc".source = link "${configDir}/dot_zshrc";
  };
}
