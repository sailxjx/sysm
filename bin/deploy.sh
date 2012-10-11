#!/usr/bin/env bash
BASEDIR=$(dirname $0)

echo "step1: compile all coffee scripts to js from source to public"
coffee -o $BASEDIR/public -c $BASEDIR/static

echo "step2: start app"
coffee $BASEDIR/app
