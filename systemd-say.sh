#!/bin/sh
printf "%s\n" "say ${*}" > /run/minecraft-stdin.fifo

