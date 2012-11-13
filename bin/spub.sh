#!/bin/bash
# rsync publish to servers

# $1 pname
# $2 url
# $3 version

PREFIX='/tmp/pub/'
USERNAME='hudson'
PASSWORD='JvjLYFIr'

function hashArgv() {
    for i in $*; do
        echo $i
    done
}

hashArgv $*

[[ ! $1 ]] && echo 'pname is null' && exit 1
[[ ! $2 ]] && echo 'url is null' && exit 1

LOCAL_DIR=${PREFIX}$1
if [[ -d $LOCAL_DIR ]]; then
    echo "local dir[${LOCAL_DIR}] is exsit, delete first"
    rm -rf $LOCAL_DIR
fi