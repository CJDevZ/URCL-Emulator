# CAL
function urcl:run/arg/load_addr/_
execute store result storage urcl:temp value int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/ops/stack/push

execute store result score @s urcl.runtime.curLine run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players remove @s urcl.runtime.curLine 1