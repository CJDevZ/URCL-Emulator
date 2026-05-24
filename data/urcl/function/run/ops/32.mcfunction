# PSH
scoreboard players operation $op_code urcl.runtime *= 8388608 __int__
data modify storage urcl:runtime workspace.stack append value 0
function urcl:run/arg/load_addr/_
execute store result storage urcl:runtime workspace.stack[-1] int 1 run function urcl:run/arg/get/_ with storage urcl:temp