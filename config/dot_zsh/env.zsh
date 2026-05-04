export XDG_CONFIG_HOME="$HOME/.config"

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'

export EDITOR=nvim

# GH_TOKEN from pass (Linux only, where no system keyring is available)
if [[ ${OSTYPE} == linux* ]] && command -v pass &>/dev/null; then
  export GH_TOKEN=$(pass show gh/token 2>/dev/null)
fi
