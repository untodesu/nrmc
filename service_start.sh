#!/bin/sh

export LANG=C.UTF-8
export LANGUAGE=C.UTF-8
export LC_ALL=C.UTF-8

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
server_jar="${PWD}/paper-1.20.4-497.jar"

nice -n -10 java ${jvm_args} -jar ${server_jar} ${server_args}

exit 0
