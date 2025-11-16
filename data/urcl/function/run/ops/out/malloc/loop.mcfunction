execute unless data storage urcl:temp copy_malloc[] run return fail

execute store result score &malloc urcl.temp run data get storage urcl:temp copy_malloc[0].index
scoreboard players operation &malloc urcl.temp -= &prev_next_malloc urcl.temp
execute if score &malloc urcl.temp >= value= urcl.runtime run return run function urcl:run/ops/out/malloc/found with storage urcl:temp
execute store result score &prev_next_malloc urcl.temp run data get storage urcl:temp copy_malloc[0].next
execute store result storage urcl:temp mem_addr int 1 run scoreboard players add malloc_index urcl.temp 1

data remove storage urcl:temp copy_malloc[0]
return run function urcl:run/ops/out/malloc/loop