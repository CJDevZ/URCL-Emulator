# POP
execute store result score val= urcl.runtime run function urcl:run/ops/stack/pop with storage urcl:temp
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/load_addr/direct
function urcl:run/arg/set/register with storage urcl:temp