# OR
scoreboard players operation $op_code urcl.runtime *= 4194304 __int__
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/load_addr/direct

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/load_addr/direct
execute store result score >A bitlib run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/load_addr/direct
execute store result score >B bitlib run function urcl:run/arg/get/_ with storage urcl:temp

execute store result score out= urcl.runtime run function bitlib:api/or
function urcl:run/arg/set/register with storage urcl:temp