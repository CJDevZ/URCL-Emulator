# BNE
scoreboard players operation $op_code urcl.runtime *= 2097152 __int__
function urcl:run/arg/load_addr/_
execute store success score out_type= urcl.runtime if predicate urcl:arg/register
execute store result storage urcl:temp out_val int 1 run scoreboard players get val= urcl.runtime
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

function urcl:run/arg/load_addr/_
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
scoreboard players operation $op_code urcl.runtime += $op_code urcl.runtime

function urcl:run/arg/load_addr/_
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
execute if score #1 urcl.math = #2 urcl.math run return fail

execute store result score @s urcl.runtime.curLine run function urcl:run/arg/get/out_val with storage urcl:temp
scoreboard players remove @s urcl.runtime.curLine 1