#!/bin/sh

# the script is located in the server root
# so it's a good idea for us to cd there...
cd $(realpath $(dirname ${0}))

unset jvm_args
jvm_args="${jvm_args} -Xms1024M"
jvm_args="${jvm_args} -Xmx8192M"
jvm_args="${jvm_args} -XX:ActiveProcessorCount=4"

unset server_args
server_args="${server_args} --nogui"
server_args="${server_args} --universe save"

unset server_jar
server_jar="${PWD}/paper-1.20.1-108.jar"

action=${1}
shift 1

# Start if not running
if test ${action} = watch; then
    if ! screen -list | grep -q nrmc; then
        screen -dmS nrmc java ${jvm_args} -jar ${server_jar} ${server_args}
        exit 0
    fi

    exit 0
fi

# Start or restart the server
if test ${action} = start || test ${action} = restart; then
    if screen -list | grep -q nrmc; then
        screen -XS nrmc stuff "save-all\\015"
        screen -XS nrmc stuff "kick @a Server is restarting\\015"
        screen -XS nrmc stuff "stop\\015"
        sleep 5
        screen -XS nrmc quit > /dev/null 2>&1
    fi

    screen -dmS nrmc java ${jvm_args} -jar ${server_jar} ${server_args}
    exit 0
fi

# Send a text command
if test ${action} = stuff; then
    screen -XS nrmc stuff "${*}\\015" > /dev/null 2>&1
    exit 0
fi

# Clobber the session
if test ${action} = stop; then
    screen -XS nrmc stuff "save-all\\015"
    screen -XS nrmc stuff "stop\\015"
    screen -XS nrmc quit > /dev/null 2>&1
    exit 0
fi

exit 0
