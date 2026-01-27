execute store result storage urcl:temp type_idx int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp val_idx int 1 run scoreboard players add @s urcl.runtime.curLine 1
return run function urcl:run/arg/load_addr/macro with storage urcl:temp