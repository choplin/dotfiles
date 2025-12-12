if command -v go > /dev/null; then
    export GOROOT=$(go env GOROOT)
    export GOPATH=$HOME/.go
    path=("$GOROOT/bin" "$GOPATH/bin" $path)
fi
