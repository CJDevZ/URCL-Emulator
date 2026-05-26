# NEG
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp

execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score out= urcl.runtime run function urcl:run/arg/get/register with storage urcl:temp
scoreboard players operation out= urcl.runtime *= -1 __int__

function urcl:run/arg/set/register with storage urcl:temp