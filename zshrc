case ${OSTYPE} in
  darwin*)
    if test -d /opt/homebrew; then
        eval $(/opt/homebrew/bin/brew shellenv)
    fi
    ;;
  linux*)
    if test -d /home/linuxbrew/.linuxbrew; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
    ;;
esac

eval "$(sheldon source)"

