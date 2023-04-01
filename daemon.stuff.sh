#!/bin/bash

cd "$(realpath $(dirname ${BASH_SOURCE[0]}))"
source "${PWD}/config/daemon.conf"

if screen -list | grep -q ${server_screen}
then
    screen -p 0 -S ${server_screen} -X stuff "${*:1}\\015"
    exit 0
fi

>&2 printf "server is not running\n"
exit 1
