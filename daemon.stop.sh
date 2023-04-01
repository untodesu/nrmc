#!/bin/bash

cd "$(realpath $(dirname ${0}))"
source "$(realpath $(dirname ${0}))/config/daemon.conf"

if screen -list | grep -q ${server_screen}
then
    screen -p 0 -S ${server_screen} -X stuff "say Server shutdown in 30 seconds\\015"
    sleep 20
    screen -p 0 -S ${server_screen} -X stuff "say Server shutdown in 10 seconds\\015"
    screen -p 0 -S ${server_screen} -X stuff "save-all\\015"
    sleep 10
    screen -p 0 -S ${server_screen} -X stuff "kick @p Server shut down for maintenance\\015"
    screen -p 0 -S ${server_screen} -X stuff "stop\\015"
    sleep 10
    screen -p 0 -S ${server_screen} -X kill > /dev/null 2> /dev/null
    exit 0
fi

>&2 printf "server is not running\n"
exit 1
