#!/bin/sh

unset jvm_args
jvm_args="${jvm_args} -Xms1024M"
jvm_args="${jvm_args} -Xmx8192M"
jvm_args="${jvm_args} -XX:ActiveProcessorCount=4"
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
server_path="${PWD}/paper-1.19.4-492.jar"

java -server ${jvm_args} -jar "${server_path}" ${server_args}

# If java fails, we want to notify systemd
# that we would appreciate it to try again
# in a minute or so (see nrmc.service)
exit ${?}
