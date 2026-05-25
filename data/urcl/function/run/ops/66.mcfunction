# LLOD
scoreboard players operation $op_code urcl.runtime *= 4194304 __int__
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/load_addr/direct

execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/load_addr/direct
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/load_addr/direct
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
execute store result storage urcl:temp pointer int 1 run scoreboard players operation #1 urcl.math += #2 urcl.math

execute store result score out= urcl.runtime run function urcl:run/ops/ram/get with storage urcl:temp
function urcl:run/arg/set/register with storage urcl:temp