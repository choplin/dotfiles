{configDir, ...}: {
  # ~/.config/* -> config/dot_config/*
  xdg.configFile = {
    "broot".source = "${configDir}/dot_config/broot";
    "lazygit".source = "${configDir}/dot_config/lazygit";
    "luacheck".source = "${configDir}/dot_config/luacheck";
    "mise".source = "${configDir}/dot_config/mise";
    "nvim".source = "${configDir}/dot_config/nvim";
    "ripgrep".source = "${configDir}/dot_config/ripgrep";
    "sheldon".source = "${configDir}/dot_config/sheldon";
    "starship.toml".source = "${configDir}/dot_config/starship.toml";
    "wezterm".source = "${configDir}/dot_config/wezterm";
    "yazi".source = "${configDir}/dot_config/yazi";
    "zsh".source = "${configDir}/dot_config/zsh";
  };

  # ~/* -> config/dot_*
  home.file = {
    ".clang-format".source = "${configDir}/dot_clang-format";
    ".claude".source = "${configDir}/dot_claude";
    ".direnvrc".source = "${configDir}/dot_direnvrc";
    ".editorconfig".source = "${configDir}/dot_editorconfig";
    ".git-scripts".source = "${configDir}/dot_git-scripts";
    ".gitattributes".source = "${configDir}/dot_gitattributes";
    ".gitconfig".source = "${configDir}/dot_gitconfig";
    ".gitignore_global".source = "${configDir}/dot_gitignore_global";
    ".ideavimrc".source = "${configDir}/dot_ideavimrc";
    ".tigrc".source = "${configDir}/dot_tigrc";
    ".tmux.conf".source = "${configDir}/dot_tmux.conf";
    ".vimrc".source = "${configDir}/dot_vimrc";
    ".zsh".source = "${configDir}/dot_zsh";
    ".zshrc".source = "${configDir}/dot_zshrc";
  };
}
