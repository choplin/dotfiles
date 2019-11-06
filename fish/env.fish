set theme_color_scheme solarized-light

set -x ANT_OPTS -Dfile.encoding=UTF8
set -x DEFAULT_USER okuno
set -x MAVEN_OPTS "-Dfile.encoding=UTF-8"
set -x EDITOR vim
set -x VISUAL vim

set -U fish_user_paths
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

switch (uname)
    case Linux
        if test -d /home/linuxbrew/.linuxbrew
            begin
                set -l brew_prefix (/home/linuxbrew/.linuxbrew/bin/brew --prefix)
                set -U fish_user_paths $brew_prefix/bin $brew_prevfix/sbin $fish_user_paths
                #set -x SHELL /home/linuxbrew/.linuxbrew/bin/fish
            end
        end
        #set -x DOCKER_HOST tcp://localhost:2375
        #umask 022
    case Darwin
        set -x RUST_SRC_PATH $HOME/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src
        set -x BROWSER open
        if type -q /usr/libexec/java_home
            set -x JAVA_HOME (/usr/libexec/java_home)
        end
        begin
            set -l brew_prefix (brew --prefix)
            set -U fish_user_paths $brew_prefix/bin $brew_prevfix/sbin $fish_user_paths

            if test -d $brew_prefix/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
                source $brew_prefix/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
            end
        end
    case FreeBSD NetBSD DragonFly
    case '*'
end

if which go > /dev/null
    set -x GOROOT (go env GOROOT)
    set -x GOPATH $HOME/.go
    set -U fish_user_paths $GOROOT/bin $GOPATH/bin $fish_user_paths
end

if test -d $HOME/.cargo
    set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
end

if which direnv > /dev/null
    eval (direnv hook fish)
end

