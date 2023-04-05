#!/bin/sh

console_stdin="${PWD}/systemd/console.stdin"
kickall_message="Maintenance shutdown"
service_message="Shutdown"

if systemctl list-jobs | grep -qe "reboot.target.*start"
then
    kickall_message="Server is restarting"
    service_message="Restart"
fi

printf "say ${service_message} in 30 seconds\n" > "${console_stdin}"
sleep 20

printf "say ${service_message} in 10 seconds\n" > "${console_stdin}"
printf "save-all\n" >> "${console_stdin}"
sleep 10

printf "kick @a ${kickall_message}\n" > "${console_stdin}"
printf "stop\n" > "${console_stdin}"

exit 0
