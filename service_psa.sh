#!/bin/sh

/home/und/minecraft/service.sh stuff execute at @a run playsound minecraft:block.anvil.land ambient @p \~ \~ \~ 10 0
/home/und/minecraft/service.sh stuff say ${*}
/home/und/minecraft/service.sh stuff title @a reset
/home/und/minecraft/service.sh stuff title @a subtitle \"${*}\"
/home/und/minecraft/service.sh stuff title @a title \"\"

