#!/bin/bash

getRealDir() {
    local REAL_DIR ORI_LINK_DIR BASE_FILE_DIR LINK_FILE
    [[ $2 != '' ]] && ORI_LINK_DIR="$(dirname $2)/"
    BASE_FILE_DIR=$(dirname $1)
    LINK_FILE=$(readlink $1)
    if [[ $? == 1 ]]; then
        if [[ $BASE_FILE_DIR =~ ^\/ ]]; then
            REAL_DIR=${BASE_FILE_DIR}
        else
            REAL_DIR=${ORI_LINK_DIR}${BASE_FILE_DIR}
        fi
    else
        REAL_DIR=$(getRealDir $LINK_FILE $1)
    fi
    echo $(cd $REAL_DIR && pwd) && exit 0
}

step1() {
    echo "step1: compile all coffee scripts to js from static to public"
    coffee -o $BASEDIR/public/js -c $BASEDIR/static/coffee
}

step2() {
    echo "step2: compile all scss files to css from static to public"
    scss --update -t compressed $BASEDIR/static/scss:$BASEDIR/public/css
}

step3() {
    echo "step3: start app"
    export NODE_PATH=$BASEDIR
    export NODE_ENV=$NODE_ENV
    export LD_LIBRARY_PATH=/usr/local/lib:$ZMQ_LIB_PATH
    coffee $BASEDIR/app
}

PATH=$PATH:/usr/bin:/usr/local/bin
BASEDIR=$(dirname $(getRealDir $0))
ZMQ_LIB_PATH=/usr/local/zeromq/lib
NODE_ENV="dev"

case "$1" in
    --help)
        echo "step1: compile all coffee scripts to js from static to public"
        echo "step2: compile all scss files to css from static to public"
        echo "step3: start app"
        echo "usage: deploy [1|2|3]"
        ;;
    1|2|3)
        step$1
        ;;
    *)
        step1
        step2
        step3
        ;;
esac

exit 0
