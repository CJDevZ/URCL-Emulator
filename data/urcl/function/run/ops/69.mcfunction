# IN
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp

execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result score port= urcl.runtime run function urcl:run/arg/get/memory with storage urcl:temp

scoreboard players set out= urcl.runtime 0
execute if score port= urcl.runtime matches 1 store result score out= urcl.runtime run random value 0..2147483646
execute if score port= urcl.runtime matches 2 run scoreboard players operation out= urcl.runtime = #port.dpad urcl.runtime

function urcl:run/arg/set/register with storage urcl:temp