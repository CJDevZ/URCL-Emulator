# SRS
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp

execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score >A bitlib run function urcl:run/arg/get/register with storage urcl:temp

scoreboard players operation out= urcl.runtime /= 2 __int__
execute if score out= urcl.runtime matches ..-1 run scoreboard players operation out= urcl.runtime += -2147483648 __int__
function urcl:run/arg/set/register with storage urcl:temp