execute store result storage urcl:temp mem_val int 1 run scoreboard players get @s urcl.runtime.register.99
scoreboard players add @s urcl.runtime.register.99 1
execute if score @s urcl.runtime.register.99 > #line urcl.runtime run return run function urcl:run/ops/stack/buffer_underflow
return run function urcl:run/arg/get/memory with storage urcl:temp