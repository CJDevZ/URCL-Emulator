# PSH
scoreboard players operation $op_code urcl.runtime *= 8388608 __int__
execute store result storage urcl:temp mem_val int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/memory with storage urcl:temp
execute store result score out= urcl.runtime run function urcl:run/arg/get/_ with storage urcl:temp
execute store result storage urcl:temp mem_val int 1 run scoreboard players remove @s urcl.runtime.register.99 1
function urcl:run/arg/set/memory with storage urcl:temp