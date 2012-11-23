#!/usr/bin/env bash

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

BASEDIR=$(dirname $(getRealDir $0))
NODE_ENV=dev
export NODE_PATH=$BASEDIR && export NODE_ENV=$NODE_ENV && coffee $1
