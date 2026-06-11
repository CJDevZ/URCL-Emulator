# CPY
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc1 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch2 with storage urcl:temp

execute store success score pc0_type= urcl.runtime if predicate urcl:arg/register
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/pc1 with storage urcl:temp
execute store result score out= urcl.runtime run function urcl:run/arg/get/memory with storage urcl:temp

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/pc0_type with storage urcl:temp
function urcl:run/arg/set/memory with storage urcl:temp
execute store result storage urcl:runtime curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1