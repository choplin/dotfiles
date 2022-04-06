set fish_greeting ""

set -U brew_prefix
switch (uname)
    case Linux
        set -U brew_prefix /home/linuxbrew/.linuxbrew
    case Darwin
        set -U brew_prefix /opt/homebrew
    case '*'
end


if test -e $brew_prefix
    fish_add_path $brew_prefix/bin
    fish_add_path $brew_prefix/sbin
end

if status --is-login
    . ~/.config/fish/env.fish
end

if status is-interactive
    . ~/.config/fish/aliases.fish
end

if test -e ~/.config/fish/local.fish
    . ~/.config/fish/local.fish
end

if type starship
    starship init fish | source
end
