data modify storage urcl:temp malloc set value {index:0,next:0}
execute store result storage urcl:temp malloc.index int 1 run scoreboard players operation val= urcl.runtime = &prev_next_malloc urcl.temp
execute store result storage urcl:temp malloc.next int 1 run scoreboard players operation value= urcl.runtime += &prev_next_malloc urcl.temp
$data modify storage urcl:runtime workspace.malloc insert $(mem_addr) from storage urcl:temp malloc

data modify storage urcl:temp mem_val set value 0
function urcl:run/arg/set/register with storage urcl:temp
return 1