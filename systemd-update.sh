#!/bin/bash
cd $(realpath $(dirname ${0}))
cp ${PWD}/minecraft-server.service /etc/systemd/system/minecraft-server.service
cp ${PWD}/minecraft-server.socket /etc/systemd/system/minecraft-server.socket
systemctl daemon-reload
