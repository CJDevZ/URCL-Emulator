# IMM
execute store result score out urcl.runtime run function urcl:run/arg/load_addr/direct
execute store result score val= urcl.runtime run function urcl:run/arg/load_addr/direct
execute store result storage urcl:temp mem_val int 1 run scoreboard players get out urcl.runtime
function urcl:run/arg/set/register with storage urcl:temp