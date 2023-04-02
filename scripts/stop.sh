#!/bin/sh

cd $(dirname $(realpath $(dirname ${0})))

# 2023-04-02 update
service_log="${PWD}/logs/service.log"
screen_name="$(basename ${PWD})"
mkdir -p $(dirname ${service_log})

if screen -list | grep -q ${screen_name};
then
    screen -p 0 -S ${screen_name} -X stuff "kick @a Server stopped\\015"
    screen -p 0 -S ${screen_name} -X stuff "save-all\\015"
    screen -p 0 -S ${screen_name} -X stuff "stop\\015"

    sleep 10
    screen -p 0 -S ${screen_name} -X kill > /dev/null 2> /dev/null
    printf "[%s] server stopped\n" "$(date +'%F %T')" >> "${service_log}"

    exit 0
fi

>&2 printf "server is not running\n"
exit 1
