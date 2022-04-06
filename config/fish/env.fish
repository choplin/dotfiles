fish_add_path $HOME/.local/bin $fish_user_paths

switch (uname)
    case Linux
    case Darwin
        if test -d $brew_prefix/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
            source $brew_prefix/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
        end
    case '*'
end

if test -d $HOME/.cargo
    fish_add_path $HOME/.cargo/bin
end

if which direnv > /dev/null
    eval (direnv hook fish)
end

