#!/bin/sh

# The script is always located at
# ${HOME}/<servername>/daemon/script.sh
cd $(dirname $(realpath $(dirname ${0})))

# The daemon.log file contains logged events about
# server starts, stops, commands sent through the
# stuff.sh script and start.sh watchdog trips
daemon_log="${PWD}/daemon/daemon.log"

# 2023-04-06: I have spent the entire evening trying
# to make daemonizing the server process directly behave
# but I gave up on that, so have just upgrades.
# Truly, if it ain't broke, don't touch it.
screen_name="$(basename ${PWD})"

# This is not necessary anymore as the daemon
# directory where this script is exists by definition,
# otherwise how would we actually run this script?
mkdir -p "$(dirname ${daemon_log})"

if screen -list | grep -q ${screen_name}
then
    printf "[%s] server command: %s\n" "$(date +'%F %T')" "${*}" >> "${daemon_log}"
    screen -XS ${screen_name} stuff "${*}\\015"
    exit 0
fi

>&2 printf "%s: server is not running\n" "${0}"
exit 1
