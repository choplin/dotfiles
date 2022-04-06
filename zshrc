case ${OSTYPE} in
  darwin*)
    readonly local brew_prefix='/opt/homebrew'
    ;;
  linux*)
    readonly local brew_prefix='/home/linuxbrew/.linuxbrew'
    ;;
esac
if test -d $brew_prefix; then
    path=("$brew_prefix/bin" "$brew_prefix/sbin" $path)
fi

eval "$(sheldon source)"

