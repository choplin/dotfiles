export XDG_CONFIG_HOME="$HOME/.config"

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'

export EDITOR=nvim

# GH_TOKEN from pass (Linux only, where no system keyring is available).
# Startup must never prompt: with a cold gpg-agent cache, pinentry blocks every
# new shell until it times out.  --pinentry-mode cancel makes the lookup fail
# silently, so the token is picked up only once the agent already holds the
# passphrase.  Run `gh-token-refresh` once after a reboot to unlock it; shells
# started afterwards pick it up on their own.
if [[ ${OSTYPE} == linux* ]] && command -v pass &>/dev/null; then
  export GH_TOKEN=$(PASSWORD_STORE_GPG_OPTS="--pinentry-mode cancel" pass show gh/token 2>/dev/null)

  gh-token-refresh() {
    local token
    token=$(pass show gh/token) || return 1
    export GH_TOKEN=$token
    print "GH_TOKEN refreshed."
  }
fi
