scoreboard players operation idx= urcl.runtime = @s urcl.runtime.curLine
scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp mem_val int 1 run scoreboard players add idx= urcl.runtime 1
return run function urcl:run/arg/load_addr/_direct with storage urcl:temp