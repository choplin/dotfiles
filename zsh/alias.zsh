if type lsd > /dev/null; then
    alias ls="lsd -F"
elif type exa > /dev/null; then
    alias ls=exa
fi

abbrev-alias d='docker'
abbrev-alias k='kubectl'
abbrev-alias lad='lazydocker'
abbrev-alias lag='lazygit'