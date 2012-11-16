#!/usr/bin/env bash

getRealDir() {
    ORI_LINK_DIR=''
    [[ $2 != '' ]] && ORI_LINK_DIR="$(dirname $2)/"
    BASE_FILE_DIR=$(dirname $1)
    LINK_FILE=$(readlink $1)
    if [[ $? == 1 ]]; then
        if [[ $BASE_FILE_DIR =~ ^\/ ]]; then
            echo ${BASE_FILE_DIR}
        else
            echo ${ORI_LINK_DIR}${BASE_FILE_DIR}
        fi
        exit 0
    fi
    echo $(getRealDir $LINK_FILE $1) && exit 1
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
    coffee $BASEDIR/app
}

BASEDIR=$(dirname $(getRealDir $0))

case "$1" in
    --help)
        echo "step1: compile all coffee scripts to js from static to public"
        echo "step2: compile all scss files to css from static to public"
        echo "step3: start app"
        echo "usage: deploy [1|2|3]"
        ;;
    '')
        step1
        step2
        step3
        ;;
    1|2|3)
        step$1
        ;;
    *)
        echo "please enter the correct step"
        echo "usage: deploy [1|2|3]"
        exit 1
        ;;
esac

exit 0
