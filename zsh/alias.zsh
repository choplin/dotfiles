if type lsd > /dev/null; then
    alias ls="lsd -F"
elif type exa > /dev/null; then
    alias ls=exa
fi

abbrev-alias g='git'
abbrev-alias d='docker'
abbrev-alias k='kubectl'
abbrev-alias r='ranger'
abbrev-alias ld='lazydocker'
abbrev-alias gu='gitui'

abbrev-alias -g B='| bat'
