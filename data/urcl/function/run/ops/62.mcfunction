# SSETG
scoreboard players operation $op_code urcl.runtime *= 4194304 __int__
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp

execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp

scoreboard players set out= urcl.runtime 0
execute if score #1 urcl.math > #2 urcl.math run scoreboard players set out= urcl.runtime -2147483648
function urcl:run/arg/set/register with storage urcl:temp