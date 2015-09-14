pg_initdb() {
    local version
    _pg_version || return 1

    local data=$(_pg_data $version)
    local port=$(_pg_port $version)

    cmd="$(pwd)/bin/initdb -D $data -E UTF-8 --no-locale"
    echo $cmd && eval $cmd
}

pg_start() {
    local version
    _pg_version || return 1

    local data=$(_pg_data $version)
    local port=$(_pg_port $version)

    cmd="$(pwd)/bin/pg_ctl -D $data -o '-p $port' start"
    echo $cmd && eval $cmd
}

pg_stop() {
    local version
    _pg_version || return 1

    local data=$(_pg_data $version)
    local port=$(_pg_port $version)

    cmd="$(pwd)/bin/pg_ctl -D $data stop"
    echo $cmd && eval $cmd
}

pg_psql() {
    local version
    _pg_version || return 1

    local data=$(_pg_data $version)
    local port=$(_pg_port $version)

    cmd="$(pwd)/bin/psql -p $port $@"
    echo $cmd && eval $cmd
}

pg_set_env() {
    local version
    _pg_version || return 1

    local data=$(_pg_data $version)
    local port=$(_pg_port $version)

    export PATH=$(pwd)/bin:$PATH
    export PGDATA=$data
    export PGPORT=$port
}

_pg_version() {
    version=$(basename $(pwd))
    if [ $(echo $version | grep -v 'pgsql') ]; then
        echo 'pg_* is available only in pgsql directory' 1>&2
        return 1
    fi
}

_pg_data() {
    echo "$HOME/data/$1"
}

_pg_port() {
    echo $(ruby -r 'digest/md5' -e "print (Digest::MD5.hexdigest('$1').hex % 10000 + 10000)")
}
