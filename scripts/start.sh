#!/bin/sh

cd $(dirname $(realpath $(dirname ${0})))

unset jvm_args
jvm_args="${jvm_args} -Xms1024M"
jvm_args="${jvm_args} -Xmx8192M"
jvm_args="${jvm_args} -XX:+UseG1GC"
jvm_args="${jvm_args} -XX:+ParallelRefProcEnabled"
jvm_args="${jvm_args} -XX:MaxGCPauseMillis=200"
jvm_args="${jvm_args} -XX:+UnlockExperimentalVMOptions"
jvm_args="${jvm_args} -XX:+DisableExplicitGC"
jvm_args="${jvm_args} -XX:+AlwaysPreTouch"
jvm_args="${jvm_args} -XX:G1NewSizePercent=30"
jvm_args="${jvm_args} -XX:G1MaxNewSizePercent=40"
jvm_args="${jvm_args} -XX:G1HeapRegionSize=8M"
jvm_args="${jvm_args} -XX:G1ReservePercent=20"
jvm_args="${jvm_args} -XX:G1HeapWastePercent=5"
jvm_args="${jvm_args} -XX:G1MixedGCCountTarget=4"
jvm_args="${jvm_args} -XX:InitiatingHeapOccupancyPercent=15"
jvm_args="${jvm_args} -XX:G1MixedGCLiveThresholdPercent=90"
jvm_args="${jvm_args} -XX:G1RSetUpdatingPauseTimePercent=5"
jvm_args="${jvm_args} -XX:SurvivorRatio=32"
jvm_args="${jvm_args} -XX:+PerfDisableSharedMem"
jvm_args="${jvm_args} -XX:MaxTenuringThreshold=1"

unset server_args
server_args="${server_args} --nogui"
server_args="${server_args} --universe worlds"

unset server_path
server_path="${PWD}/paper-1.19.4-484.jar"

# 2023-04-02 update
service_log="${PWD}/logs/service.log"
screen_name="$(basename ${PWD})"
mkdir -p $(dirname ${service_log})

if screen -list | grep -q ${screen_name};
then
    if [ "${1}" = "watch" ]
    then
        printf "[%s] watchdog: server is running \n" "$(date +'%F %T')" >> "${service_log}"
        exit 0
    fi

    screen -p 0 -S ${screen_name} -X stuff "kick @a Server is restarting\\015"
    screen -p 0 -S ${screen_name} -X stuff "save-all\\015"
    screen -p 0 -S ${screen_name} -X stuff "stop\\015"

    sleep 10
    screen -p 0 -S ${screen_name} -X kill > /dev/null 2> /dev/null
    printf "[%s] server stopped\n" "$(date +'%F %T')" >> "${service_log}"
fi

printf "[%s] starting server\n" "$(date +'%F %T')" >> "${service_log}"
screen -dm -S ${screen_name} java -server ${jvm_args} -jar "${server_path}" ${server_args}
exit 0
