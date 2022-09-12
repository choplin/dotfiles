if type lsd > /dev/null; then
    alias ls="lsd -F"
elif type exa > /dev/null; then
    alias ls=exa
fi

disable r
