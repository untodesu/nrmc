#!/bin/sh

cd $(dirname $(realpath $(dirname ${0})))

# 2023-04-02 update
screen_name="$(basename ${PWD})"

if screen -list | grep -q ${screen_name};
then
    screen -p 0 -S ${screen_name} -X stuff "${*}\\015"
    exit 0
fi

>&2 printf "server is not running\n"
exit 1
