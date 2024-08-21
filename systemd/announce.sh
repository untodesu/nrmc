#!/bin/sh
printf "%s\n" "execute at @a run playsound mineraft:item.goat_horn.sound.1 ambient @p ~ ~ ~ 10 1" > /run/minecraft-stdin.fifo
printf "%s\n" "say ${*}" > /run/minecraft-stdin.fifo
printf "%s\n" "title @a reset" > /run/minecraft-stdin.fifo
printf "%s\n" "title @a subtitle \"${*}\"" > /run/minecraft-stdin.fifo
printf "%s\n" "title @a title \"\"" > /run/minecraft-stdin.fifo
