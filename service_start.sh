#!/bin/sh

export LANG=C
export LANGUAGE=C
export LC_ALL=C

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
server_jar="${PWD}/paper-1.20.1-196.jar"

# minecraft doesn't need that much computing
# power, so we can have it nicer than srcds
nice -n 5 java ${jvm_args} -jar ${server_jar} ${server_args}

exit 0
