data modify storage urcl:temp copy_malloc set from storage urcl:runtime workspace.malloc
scoreboard players set &prev_next_malloc urcl.temp 0
execute store result storage urcl:temp mem_addr int 1 run scoreboard players set malloc_index urcl.temp 0

execute if function urcl:run/ops/out/malloc/loop run return 1
# Get if the rest is enough

execute store result score &malloc urcl.temp if data storage urcl:runtime workspace.memory[]
scoreboard players operation &malloc urcl.temp -= &prev_next_malloc urcl.temp
execute if score &malloc urcl.temp < value= urcl.runtime run return run scoreboard players set @s urcl.runtime.register.0 0

data modify storage urcl:temp malloc set value {index:0,next:0}
execute store result storage urcl:temp malloc.index int 1 run scoreboard players get &prev_next_malloc urcl.temp
execute store result storage urcl:temp malloc.next int 1 run scoreboard players operation value= urcl.runtime += &prev_next_malloc urcl.temp
data modify storage urcl:runtime workspace.malloc append from storage urcl:temp malloc

scoreboard players operation @s urcl.runtime.register.0 = &prev_next_malloc urcl.temp