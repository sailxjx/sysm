#!/usr/bin/env bash
BASEDIR=$(dirname $0)

step1() {
    echo "step1: compile all coffee scripts to js from static to public"
    coffee -o $BASEDIR/public/js -c $BASEDIR/static/coffee
}

step2() {
    echo "step2: compile all scss files to css from static to public"
    scss --update -f -t expanded $BASEDIR/static/scss:$BASEDIR/public/css
}

step3() {
    echo "step3: start app"
    coffee $BASEDIR/app
}

if [[ $1 != '' ]]; then
    step$1
else
    step1
    step2
    step3
fi

exit 0
