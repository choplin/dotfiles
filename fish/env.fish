set theme_color_scheme solarized-light

set -x JAVA_HOME (/usr/libexec/java_home)
set -x ANT_OPTS -Dfile.encoding=UTF8

set -x DEFAULT_USER okuno

set -x MAVEN_OPTS "-Dfile.encoding=UTF-8"

set -x EDITOR vim
set -x VISUAL vim

set -x RUST_SRC_PATH $HOME/.rustup/toolchains/nightly-x86_64-apple-darwin/lib/rustlib/src/rust/src

set -x BROWSER open

set -U fish_user_paths

if which go > /dev/null
    set -x GOROOT /usr/local/opt/go/libexec
    set -x GOPATH $HOME/.go
    set -U fish_user_paths $GOROOT/bin $GOPATH/bin $fish_user_paths
end

if test -d $HOME/.cargo
    set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
end

if which direnv > /dev/null
    eval (direnv hook fish)
end
