# SETG
scoreboard players operation $op_code urcl.runtime *= 4194304 __int__
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc1 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc2 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch3 with storage urcl:temp

execute store result score #1 urcl.math run function urcl:run/arg/get/pc1 with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

execute store result score #2 urcl.math run function urcl:run/arg/get/pc2 with storage urcl:temp

scoreboard players set out= urcl.runtime 0
execute if score #1 urcl.math > #2 urcl.math run scoreboard players set out= urcl.runtime -2147483648
function urcl:run/arg/set/register/pc0 with storage urcl:temp
execute store result storage urcl:runtime curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1