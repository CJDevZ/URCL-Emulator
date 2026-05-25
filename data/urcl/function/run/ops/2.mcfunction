# LOD
scoreboard players operation $op_code urcl.runtime *= 8388608 __int__
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/load_addr/direct

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/load_addr/direct
execute store result storage urcl:temp pointer int 1 run function urcl:run/arg/get/_ with storage urcl:temp

execute store result score out= urcl.runtime run function urcl:run/ops/ram/get with storage urcl:temp
function urcl:run/arg/set/register with storage urcl:temp