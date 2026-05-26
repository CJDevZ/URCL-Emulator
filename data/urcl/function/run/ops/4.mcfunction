# BGE
scoreboard players operation $op_code urcl.runtime *= 2097152 __int__
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store success score out_type= urcl.runtime if predicate urcl:arg/register
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
execute if score #1 urcl.math matches ..-1 if score #2 urcl.math matches 0.. run return fail
execute if score #1 urcl.math matches ..-1 run scoreboard players add #1 urcl.math 2147483647
execute if score #2 urcl.math matches ..-1 run scoreboard players add #2 urcl.math 2147483647
execute unless score #1 urcl.math >= #2 urcl.math run return fail

execute store result score @s urcl.runtime.curLine run function urcl:run/arg/get/out_val with storage urcl:temp
scoreboard players remove @s urcl.runtime.curLine 1