# XOR
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc1 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc2 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch3 with storage urcl:temp

execute store result score >A bitlib run function urcl:run/arg/get/pc1 with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

execute store result score >B bitlib run function urcl:run/arg/get/pc2 with storage urcl:temp

execute store result score out= urcl.runtime run function bitlib:api/xor
function urcl:run/arg/set/register/pc0 with storage urcl:temp
execute store result storage urcl:runtime curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1