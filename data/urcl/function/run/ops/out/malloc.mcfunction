execute if score value= urcl.runtime matches ..0 run return run scoreboard players set @s urcl.runtime.register.0 0
execute if data storage urcl:runtime workspace.malloc[] run return run function urcl:run/ops/out/malloc/search_free with storage urcl:temp
data modify storage urcl:temp malloc set value {index:0,next:0}
execute store result storage urcl:temp malloc.next int 1 run scoreboard players get value= urcl.runtime
data modify storage urcl:runtime workspace.malloc append from storage urcl:temp malloc
scoreboard players operation @s urcl.runtime.register.0 = value= urcl.runtime