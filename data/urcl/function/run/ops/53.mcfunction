# SBGE
function urcl:run/arg/load_addr/_
scoreboard players operation out_type= urcl.runtime = type= urcl.runtime
execute store result storage urcl:temp out_val int 1 run scoreboard players get val= urcl.runtime

function urcl:run/arg/load_addr/_
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp

function urcl:run/arg/load_addr/_
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
execute unless score #1 urcl.math >= #2 urcl.math run return fail

execute store result score @s urcl.runtime.curLine run function urcl:run/arg/get/out_val with storage urcl:temp
scoreboard players remove @s urcl.runtime.curLine 1