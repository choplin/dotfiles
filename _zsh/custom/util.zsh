# aliases {{{
alias be="bundle exec"
alias killsbt="ps -ef | grep java | grep '.sbt/boot' | awk '{print $2}' | xargs kill"
unalias gb
# }}}

# functions {{{
light() {
    local syntax=$1

    local src=''
    if [ -z "$2" ]; then
        src="pbpaste"
    else
        src="cat $2"
    fi

    ${src} | highlight \
                --syntax=${syntax} \
                --style=solarized-light \
                -O rtf \
                --font=Ricty \
                --font-size 24 | pbcopy
}

docker-bash() {
    docker run --rm -it $1 bash
}
# }}}
