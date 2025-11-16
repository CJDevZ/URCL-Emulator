execute if score value= urcl.runtime matches ..0 run return run function urcl:run/ops/out/return_nullptr
execute if data storage urcl:runtime workspace.malloc[] run return run function urcl:run/ops/out/malloc/search_free with storage urcl:temp
data modify storage urcl:temp malloc set value {index:0,next:0}
execute store result storage urcl:temp malloc.next int 1 store result score val= urcl.runtime run scoreboard players get value= urcl.runtime
data modify storage urcl:runtime workspace.malloc append from storage urcl:temp malloc
data modify storage urcl:temp mem_val set value 0
function urcl:run/arg/set/register with storage urcl:temp