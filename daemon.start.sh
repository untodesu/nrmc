#!/bin/bash

cd "$(realpath $(dirname ${BASH_SOURCE[0]}))"
source "${PWD}/config/daemon.conf"

if screen -list | grep -q ${server_screen}
then
    if [ "${1}" == "watch" ]
    then
        # The server is running, this means we
        # don't need to start the server again
        exit 0
    else
        screen -p 0 -S ${server_screen} -X stuff "say Server restart in 30 seconds\\015"
        sleep 20
        screen -p 0 -S ${server_screen} -X stuff "say Server restart in 10 seconds\\015"
        screen -p 0 -S ${server_screen} -X stuff "save-all\\015"
        sleep 10
        screen -p 0 -S ${server_screen} -X stuff "kick @a Server is restarting\\015"
        screen -p 0 -S ${server_screen} -X stuff "stop\\015"
        sleep 10
        screen -p 0 -S ${server_screen} -X kill > /dev/null 2> /dev/null
    fi
fi

screen -dm -S ${server_screen} java -server ${jvm_args[@]} -jar "$(realpath $(dirname ${0}))/${server_jar}" ${server_args[@]} --nogui
exit 0
