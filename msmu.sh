#!/bin/sh

self=$(basename ${0})
action=${1}
instance=${2}
instance_dir="${HOME}/.msmu/${instance}"
instance_conf="${instance_dir}/instance.conf"
instance_start="${instance_dir}/start.sh"
instance_stop="${instance_dir}/stop.sh"
instance_screen="msmu-${instance}"

conf_jvm_args=""
conf_jvm_xms="256M"
conf_jvm_xmx="2048M"
conf_server_args=""
conf_server_cwd="${HOME}/${instance}"
conf_server_jar="${HOME}/server.jar"

if [ -z ${action} ] || [ -z ${instance} ]
then
    >&2 printf "usage: %s <action> <instance> [options]\n" ${self}
    exit 1
fi

shift 2

store_config() {
    truncate -s 0 ${instance_conf}
    printf "conf_jvm_args='%s'\n"       "${conf_jvm_args}"      >> ${instance_conf}
    printf "conv_jvm_xms='%s'\n"        "${conf_jvm_xms}"       >> ${instance_conf}
    printf "conf_jvm_xmx='%s'\n"        "${conf_jvm_xmx}"       >> ${instance_conf}
    printf "conf_server_args='%s'\n"    "${conf_server_args}"   >> ${instance_conf}
    printf "conf_server_cwd='%s'\n"     "${conf_server_cwd}"    >> ${instance_conf}
    printf "conf_server_jar='%s'\n"     "${conf_server_jar}"    >> ${instance_conf}
}

send_line() {
    joined="${@}"
    screen -p 0 -S ${instance_screen} -X stuff "${joined}\\015"
}

# Action: create <instance> [options]
if [ ${action} = "create" ]
then
    if [ -f ${instance_conf} ]
    then
        >&2 printf "%s: unable to create %s: instance exists\n" ${action} ${instance}
        exit 1
    fi

    while getopts "s:x:d:j:h" opt
    do
        case ${opt} in
            s) conf_jvm_xms="${OPTARG}";;
            x) conf_jvm_xmx="${OPTARG}";;
            d) conf_server_cwd="${OPTARG}";;
            j) conf_server_jar="${OPTARG}";;
            h) >&2 printf "usage: %s %s <instance> [-sxdjh]\n" ${self} ${action}; exit 0;;
        esac
    done

    conf_server_cwd=$(realpath ${conf_server_cwd})
    conf_server_jar=$(realpath ${conf_server_jar})

    mkdir -p ${instance_dir}
    touch ${instance_conf}
    touch ${instance_start}
    touch ${instance_stop}

    store_config

    exit 0
fi

# Action: config <instance> [options]
if [ ${action} = "config" ]
then
    if [ ! -f ${instance_conf} ]
    then
        >&2 printf "%s: unable to configure %s: instance doesn't exist\n" ${action} ${instance}
        exit 1
    fi

    source ${instance_conf} 2> /dev/null || . ${instance_conf} || exit 1

    while getopts "s:x:d:j:s:v:SVh" opt
    do
        case ${opt} in
            s) conf_jvm_xms="${OPTARG}";;
            x) conf_jvm_xmx="${OPTARG}";;
            d) conf_server_cwd="${OPTARG}";;
            j) conf_server_jar="${OPTARG}";;
            s) conf_server_args="${OPTARG} ${conf_server_args}";;
            v) conf_jvm_args="${OPTARG} ${conf_jvm_args}";;
            S) conf_server_args="";;
            v) conf_jvm_args="";;
            h) >&2 printf "usage: %s %s <instance> [-sxdjsvSVh]\n" ${self} ${action}; exit 0;;
        esac
    done

    conf_server_cwd=$(realpath ${conf_server_cwd})
    conf_server_jar=$(realpath ${conf_server_jar})

    store_config

    exit 0
fi


# Action: start <instance>
if [ ${action} = "start" ]
then
    if [ ! -f ${instance_conf} ]
    then
        >&2 printf "%s: unable to start %s: instance doesn't exist\n" ${action} ${instance}
        >&2 printf "%s: suggestion: %s create %s\n" ${action} ${self} ${instance}
        exit 1
    fi

    if screen -list | grep -q ${instance_screen}
    then
        >&2 printf "%s: unable to start %s: instance is already running\n" ${action} ${instance}
        exit 1
    fi

    source ${instance_conf} 2> /dev/null || . ${instance_conf} || exit 1

    conf_server_cwd=$(realpath ${conf_server_cwd})
    conf_server_jar=$(realpath ${conf_server_jar})

    cd ${conf_server_cwd}
    source ${instance_start} 2> /dev/null || . ${instance_start} 2> /dev/null
    screen -dm -S ${instance_screen} java -server ${conf_jvm_args} -Xms${conf_jvm_xms} -Xmx${conf_jvm_xmx} -jar ${conf_server_jar} ${conf_server_args} --nogui
    exit 0
fi

# Action: stop <instance>
if [ ${action} = "stop" ]
then
    if ! screen -list | grep -q ${instance_screen}
    then
        >&2 printf "%s: unable to stop %s: instance is not running\n" ${action} ${instance}
        exit 1
    fi

    source ${instance_stop} 2> /dev/null || . ${instance_stop} 2> /dev/null

    send_line save-all
    send_line stop

    while screen -list | grep -q ${instance_screen}
    do
        >&2 printf "%s: awaiting for instance %s to stop\n" ${action} ${instance}
        sleep 1
    done

    exit 0
fi

# Action: send <instance>
if [ ${action} = "send" ]
then
   if ! screen -list | grep -q ${instance_screen}
   then
      >&2 printf "%s: unable to send to %s: instance is not running\n" ${action} ${instance}
      exit 1
   fi

   send_line ${@}
   exit 0
fi
