# CPY
scoreboard players operation $op_code urcl.runtime *= 4194304 __int__
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store success score out_type= urcl.runtime if predicate urcl:arg/register
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime


execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/_ with storage urcl:temp
execute store result score #1 urcl.math run function urcl:run/arg/get/memory with storage urcl:temp

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/out_val with storage urcl:temp
function urcl:run/arg/set/memory with storage urcl:temp