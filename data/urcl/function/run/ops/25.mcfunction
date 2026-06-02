# BOD
scoreboard players operation $op_code urcl.runtime *= 8388608 __int__
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc1 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch2 with storage urcl:temp

execute store success score pc0_type= urcl.runtime if predicate urcl:arg/register

execute store result score #1 urcl.math run function urcl:run/arg/get/register/pc1 with storage urcl:temp
scoreboard players operation #1 urcl.math %= 2 __int__
execute if score #1 urcl.math matches 0 store result storage urcl:runtime curLine int 1 run return run scoreboard players add @s urcl.runtime.curLine 1

execute store result score @s urcl.runtime.curLine store result storage urcl:runtime curLine int 1 run function urcl:run/arg/get/pc0_type with storage urcl:temp