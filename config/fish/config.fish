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

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
