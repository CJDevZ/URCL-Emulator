# POP
execute store result score out= urcl.runtime run function urcl:run/ops/stack/pop
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch1 with storage urcl:temp
function urcl:run/arg/set/register/pc0 with storage urcl:temp
execute store result storage urcl:runtime curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1