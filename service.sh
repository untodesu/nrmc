#!/bin/sh

export LANG=C.UTF-8
export LANGUAGE=C.UTF-8
export LC_ALL=C.UTF-8

# the script is located in the server root
# so it's a good idea for us to cd there...
cd $(realpath $(dirname ${0}))

action=${1}
shift 1

# Start if not running
if test ${action} = watch; then
    if ! screen -list | grep -q minecraft; then
        screen -dmS minecraft ${PWD}/service_start.sh
        exit 0
    fi

    exit 0
fi

# Start or restart the server
if test ${action} = start || test ${action} = restart; then
    if screen -list | grep -q minecraft; then
        screen -XS minecraft stuff "kick @a Server is restarting\\015"
        screen -XS minecraft stuff "save-all\\015"
        screen -XS minecraft stuff "stop\\015"
        sleep 5
        screen -XS minecraft quit > /dev/null 2>&1
    fi

    screen -dmS minecraft ${PWD}/service_start.sh
    exit 0
fi

# Send a text command
if test ${action} = stuff; then
    screen -XS minecraft stuff "${*}\\015" > /dev/null 2>&1
    exit 0
fi

# Clobber the session
if test ${action} = stop; then
    screen -XS minecraft stuff "kick @a Server is stopping\\015"
    screen -XS minecraft stuff "save-all\\015"
    screen -XS minecraft stuff "stop\\015"
    screen -XS minecraft quit > /dev/null 2>&1
    exit 0
fi

exit 0
