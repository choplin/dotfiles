if [ -d $HOME/.zplug ]; then
    source ~/.zplug/zplug

    # Can manage a plugin as a command
    # zplug "junegunn/dotfiles", as:command, of:bin/vimcat

    # Can manage everything e.g., other person's zshrc
    zplug "tcnksm/docker-alias", of:zshrc

    # Prohibit updates to a plugin by using the "frozen:" tag
    zplug "k4rthik/git-cal", as:command, frozen:1

    # Grab binaries from GitHub Releases
    # and rename to use "file:" tag
    # zplug "junegunn/fzf-bin", \
        # as:command, \
        # from:gh-r, \
        # file:fzf

    # Support oh-my-zsh plugins and the like
    # zplug "plugins/git",   from:oh-my-zsh
    # zplug "themes/duellj", from:oh-my-zsh
    # zplug "lib/clipboard", from:oh-my-zsh

    # Run a command after a plugin is installed/updated
    # zplug "tj/n", do:"make install"

    # Support checking out a specific branch/tag/commit of a plugin
    # zplug "b4b4r07/enhancd", at:v1
    # zplug "mollifier/anyframe", commit:4c23cb60

    # Install if "if:" tag returns true
    # zplug "hchbaw/opp.zsh", if:"(( ${ZSH_VERSION%%.*} < 5 ))"

    # Can manage gist file just like other plugins
    # zplug "b4b4r07/79ee61f7c140c63d2786", \
        # from:gist, \
        # as:command, \
        # of:get_last_pane_path.sh

    # Group dependencies, emoji-cli depends on jq in this example
    # zplug "stedolan/jq", \
        # as:command, \
        # file:jq, \
        # from:gh-r \
        # | zplug "b4b4r07/emoji-cli"

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    # Then, source plugins and add commands to $PATH
    zplug load
fi
