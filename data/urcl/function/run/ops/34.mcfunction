# CAL
function urcl:run/arg/load_addr/_

data modify storage urcl:runtime workspace.stack append value 0
execute store result storage urcl:runtime workspace.stack[-1] int 1 run scoreboard players add @s urcl.runtime.curLine 1

execute store result score @s urcl.runtime.curLine run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players remove @s urcl.runtime.curLine 1