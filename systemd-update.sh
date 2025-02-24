#!/bin/bash
cd $(realpath $(dirname ${0}))
cp ${PWD}/minecraft.service /etc/systemd/system/minecraft.service
cp ${PWD}/minecraft.socket /etc/systemd/system/minecraft.socket
systemctl daemon-reload
