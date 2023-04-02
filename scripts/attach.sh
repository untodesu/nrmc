#!/bin/sh

cd $(dirname $(realpath $(dirname ${0})))

# 2023-04-02 update
screen_name="$(basename ${PWD})"

if screen -list | grep -q ${screen_name};
then
    screen -r ${screen_name}
    exit 0
fi

>&2 printf "server is not running\n"
exit 1
