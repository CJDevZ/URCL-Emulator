data modify storage urcl:temp malloc set value {index:0,next:0}
execute store result storage urcl:temp malloc.index int 1 run scoreboard players get &prev_next_malloc urcl.temp
execute store result storage urcl:temp malloc.next int 1 run scoreboard players operation value= urcl.runtime += &prev_next_malloc urcl.temp
$data modify storage urcl:runtime workspace.malloc insert $(mem_addr) from storage urcl:temp malloc

scoreboard players operation @s urcl.runtime.register.0 = &prev_next_malloc urcl.temp
return 1