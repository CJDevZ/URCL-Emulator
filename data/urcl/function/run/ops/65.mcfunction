# SSETLE
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/load_addr/direct

function urcl:run/arg/load_addr/_
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp

function urcl:run/arg/load_addr/_
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp

scoreboard players set out= urcl.runtime 0
execute if score #1 urcl.math <= #2 urcl.math run scoreboard players set out= urcl.runtime -2147483648
function urcl:run/arg/set/register with storage urcl:temp