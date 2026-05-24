# STR
scoreboard players operation $op_code urcl.runtime *= 4194304 __int__
function urcl:run/arg/load_addr/_
execute store result storage urcl:temp pointer int 1 run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

function urcl:run/arg/load_addr/_
execute store result storage urcl:temp value int 1 run function urcl:run/arg/get/_ with storage urcl:temp
function urcl:run/ops/ram/set with storage urcl:temp