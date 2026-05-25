# BEV
scoreboard players operation $op_code urcl.runtime *= 4194304 __int__
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/load_addr/direct
execute store success score out_type= urcl.runtime if predicate urcl:arg/register

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/load_addr/direct
execute store result score #1 urcl.math run function urcl:run/arg/get/register with storage urcl:temp
scoreboard players operation #1 urcl.math %= 2 __int__
execute if score #1 urcl.math matches 1 run return fail

execute store result score @s urcl.runtime.curLine run function urcl:run/arg/get/out_val with storage urcl:temp
scoreboard players remove @s urcl.runtime.curLine 1