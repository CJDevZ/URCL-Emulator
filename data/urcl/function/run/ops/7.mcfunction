# JMP
scoreboard players operation $op_code urcl.runtime *= 8388608 __int__
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score @s urcl.runtime.curLine run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players remove @s urcl.runtime.curLine 1