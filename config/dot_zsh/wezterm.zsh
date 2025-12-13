# Detect OS and return the appropriate base64 option
local _wez_base64_option() {
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "-b 0"
    else
        echo "-w 0"
    fi
}

# Send a notification with wezterm use like `do think && weznot "think is done"`
function weznot() {
    title=$1
    base64_opt=$(_wez_base64_option)
    printf "\033]1337;SetUserVar=%s=%s\007" wez_not $(echo -n "$title" | base64 $base64_opt)
}

# Pipeline content to the clipboard `echo "hello" | wezcopy`
function wezcopy() {
    clip_stuff=$(cat)
    base64_opt=$(_wez_base64_option)
    printf "\033]1337;SetUserVar=%s=%s\007" wez_copy $(echo -n "$clip_stuff" | base64 $base64_opt)
}

# Run a command and notify that the command has failed or succeeded
function wezmon() {
    command=$*

    eval $command

    last_exit_code=$?
    if [ $last_exit_code -eq 0 ]; then
        weznot "✅ '$command' completed successfully"
    else
        weznot "❌ '$command' failed"
    fi
}
