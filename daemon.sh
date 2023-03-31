#!/bin/bash

jvm_args=()
srv_args=()
srv_name="nrmc"
srv_path="server.jar"

jvm_args+=(-Xms512M)
jvm_args+=(-Xmx8192M)
jvm_args+=(-XX:ActiveProcessorCount=2)

srv_args+=(--nogui)
srv_args+=(--universe save)

cd $(realpath $(dirname ${0}))

if [ "${1}" == "start" ]
then
    if screen -list | grep -q ${srv_name}
    then
        screen -p 0 -S ${srv_name} -X stuff "say Scheduled restart in 30 seconds\\015"
        sleep 20
        screen -p 0 -S ${srv_name} -X stuff "say Scheduled restart in 10 seconds\\015"
        screen -p 0 -S ${srv_name} -X stuff "save-all\\015"
        sleep 10
        screen -p 0 -S ${srv_name} -X stuff "kick @p Server is restarting\\015"
        screen -p 0 -S ${srv_name} -X stuff "stop\\015"
        while screen -list | grep -q ${srv_name}
        do
            sleep 1
        done
    fi
    screen -dm -S ${srv_name} java -server ${jvm_args[*]} -jar ${srv_path} ${srv_args[*]}
    exit 0
fi

if [ "${1}" == "stop" ]
then
    if screen -list | grep -q ${srv_name}
    then
        screen -p 0 -S ${srv_name} -X stuff "say Scheduled shutdown in 30 seconds\\015"
        sleep 20
        screen -p 0 -S ${srv_name} -X stuff "say Scheduled shutdown in 10 seconds\\015"
        screen -p 0 -S ${srv_name} -X stuff "save-all\\015"
        sleep 10
        screen -p 0 -S ${srv_name} -X stuff "kick @p Server is down for maintenance\\015"
        screen -p 0 -S ${srv_name} -X stuff "stop\\015"
        while screen -list | grep -q ${srv_name}
        do
            sleep 1
        done
    fi
    exit 0
fi

if [ "${1}" == "stuff" ]
then
    if screen -list | grep -q ${srv_name}
    then
        screen -p 0 -S ${srv_name} -X stuff "${*:2}\\015"
    fi
    exit 0
fi

if [ "${1}" == "attach" ]
then
    if screen -list | grep -q ${srv_name}
    then
        screen -r ${srv_name}
        exit 0
    fi
    exit 1
fi
