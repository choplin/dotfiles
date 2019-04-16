# alias & function
. ~/.config/fish/aliases.fish

# environment variables
if status --is-login
    . ~/.config/fish/env.fish
end

if test -e ~/.config/fish/local.fish
    . ~/.config/fish/local.fish
end

set fish_greeting ""
