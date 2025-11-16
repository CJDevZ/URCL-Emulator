execute store result storage urcl:temp mem_val int 1 run scoreboard players get val= urcl.runtime
data remove storage urcl:temp mem_type
execute if score type= urcl.runtime matches 1 run return run data modify storage urcl:temp mem_type set value "register"
execute if score type= urcl.runtime matches 2 run return run data modify storage urcl:temp mem_type set value "memory"
data modify storage urcl:temp mem_type set value "value"