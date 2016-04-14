# aliases {{{
alias be="bundle exec"
alias killsbt="ps -ef | grep java | grep '.sbt/boot' | awk '{print $2}' | xargs kill"
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
                --style=edit-vim-dark \
                -O rtf \
                --font=Ricty \
                --font-size 24 | pbcopy
}

docker-clean() {
    local containers=$(docker ps -a -q)
    if [ -n "$containers" ]; then
        echo "remove $(echo $containers | wc -l) containers"
        docker rm $containers
    fi

    local images=$(docker images | grep none | awk '{print $3}')
    if [ -n "$images" ]; then
        echo "remove $(echo $images | wc -l) images"
        docker rmi $images
    fi

    local volumes=$(docker volume ls -qf dangling=true)
    if [ -n "$volumes" ]; then
        echo "remove $(echo $volumes | wc -l) images"
        docker volume rm $images
    fi
}

docker-bash() {
    docker run --rm -it $1 bash
}

docker-chrome() {
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome $(docker-machine ip default)
}
# }}}
