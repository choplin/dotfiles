# 一定時間以上かかったら通知 {{{
__timetrack_threshold=10 # seconds
read -r -d '' __timetrack_ignore_progs <<EOF
less
emacs vi vim
ssh mosh telnet nc netcat
gdb
psql
tig
pry
tmux
EOF

export __timetrack_threshold
export __timetrack_ignore_progs

function __my_preexec_start_timetrack() {
    local _command="$1"

    export __timetrack_start=`date +%s`
    export __timetrack_command="$_command"
}

function __my_preexec_end_timetrack() {
    local exec_time
    local _command="$__timetrack_command"
    local prog=$(echo "$_command"|awk '{print $1}')
    local notify_method
    local message
    local title

    export __timetrack_end=`date +%s`

    if test -n "${REMOTEHOST}${SSH_CONNECTION}"; then
        notify_method="remotehost"
    elif which growlnotify >/dev/null 2>&1; then
        notify_method="growlnotify"
    elif which notify-send >/dev/null 2>&1; then
        notify_method="notify-send"
    elif which terminal-notifier >/dev/null 2>&1; then
        notify_method="terminal-notifier"
    else
        return
    fi

    if [ -z "$__timetrack_start" ] || [ -z "$__timetrack_threshold" ]; then
        return
    fi

    for ignore_prog in $(echo $__timetrack_ignore_progs); do
        [ "$prog" = "$ignore_prog" ] && return
    done

    exec_time=$((__timetrack_end-__timetrack_start))
    if [ -z "$_command" ]; then
        _command="<UNKNOWN>"
    fi

    message="Command finished! Time: $exec_time seconds. COMMAND: $_command"
    title="ZSH timetracker"

    if [ "$exec_time" -ge "$__timetrack_threshold" ]; then
        case $notify_method in
            "remotehost" )
        # show trigger string
                echo -e "\e[0;30m==ZSH LONGRUN COMMAND TRACKER==$(hostname -s): $_command ($exec_time seconds)\e[m"
        sleep 1
        # wait 1 sec, and then delete trigger string
        echo -e "\e[1A\e[2K"
                ;;
            "growlnotify" )
                echo "$message" | growlnotify -n "$title" --appIcon Terminal
                ;;
            "notify-send" )
                notify-send "$title" "$message"
                ;;
            "terminal-notifier" )
                terminal-notifier -title "$title" -message "$message"
                ;;
        esac
    fi

    unset __timetrack_start
    unset __timetrack_command
}

if which growlnotify >/dev/null 2>&1 ||
    which notify-send >/dev/null 2>&1 ||
    which terminal-notifier >/dev/null 2>&1 ||
    test -n "${REMOTEHOST}${SSH_CONNECTION}"; then
    preexec_functions=($preexec_functions __my_preexec_start_timetrack)
    precmd_functions=($precmd_functions __my_preexec_end_timetrack)
fi
# }}}
