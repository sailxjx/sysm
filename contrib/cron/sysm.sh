#!/bin/bash

PATH=$PATH:/usr/bin:/usr/local/bin
BASEDIR=/home/tristan/coding/sysm
NODE_ENV='dev'
VAR_DIR="$BASEDIR/var"
ACTION_FILE="$BASEDIR/contrib/cron/action"
VERSION_FILE="$BASEDIR/var/version"
PID_FILE="$BASEDIR/var/sysm.pid"
LOG_FILE="$BASEDIR/var/sysm.log"

tryStop() {
    if [[ -f $PID_FILE ]]; then
        SYSM_PID=$(cat $PID_FILE)
        echo "stop nodejs process $SYSM_PID"
        if [[ $SYSM_PID != '' ]]; then
            kill $SYSM_PID
        fi
        rm $PID_FILE
    else
        echo "pid file not found"
    fi
}

if [[ ! -d $VAR_DIR ]]; then
    mkdir -p $VAR_DIR
fi

if [[ -f $ACTION_FILE ]]; then
    ACTION=$(cat $ACTION_FILE)
else
    echo "no action file"
    exit 0
fi

case $ACTION in
    restart)
        tryStop
        echo "step1: compile all coffee scripts to js from static to public"
        coffee -o $BASEDIR/public/js -c $BASEDIR/static/coffee
        echo "step2: compile all scss files to css from static to public"
        scss --update -t compressed $BASEDIR/static/scss:$BASEDIR/public/css
        echo "step3: start app"
        echo "export NODE_PATH=$BASEDIR && export NODE_ENV=$NODE_ENV && nohup coffee $BASEDIR/app >> $LOG_FILE 2>&1 &"
        export NODE_PATH=$BASEDIR
        export NODE_ENV=$NODE_ENV
        coffee $BASEDIR/app >> $LOG_FILE 2>&1 &
        if [[ $? == 0 ]]; then
            echo $! > $PID_FILE
            date +%Y.%-m.%-d_%T > $VERSION_FILE
            rm $ACTION_FILE
            exit 0
        fi
        exit 1
        ;;
    *)
        echo "please set the correct action"
        exit 1
        ;;
esac