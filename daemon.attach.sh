#!/bin/bash

cd "$(realpath $(dirname ${0}))"
source "$(realpath $(dirname ${0}))/config/daemon.conf"

if screen -list | grep ${server_screen}
then
    screen -r ${server_screen}
    exit 0
fi

>&2 printf "server is not running\n"
exit 1
