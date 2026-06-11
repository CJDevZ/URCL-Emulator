# PSH
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch1 with storage urcl:temp

execute store result score out= urcl.runtime run function urcl:run/arg/get/pc0 with storage urcl:temp
execute store result storage urcl:temp mem_val int 1 run scoreboard players remove @s urcl.runtime.register.99 1
function urcl:run/arg/set/memory with storage urcl:temp

execute store result storage urcl:runtime curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1