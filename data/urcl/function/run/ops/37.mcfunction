# CPY
function urcl:run/arg/load_addr/_
scoreboard players operation out_type= urcl.runtime = type= urcl.runtime
scoreboard players operation out_val= urcl.runtime = val= urcl.runtime


function urcl:run/arg/load_addr/_
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/_ with storage urcl:temp
execute store result score #1 urcl.math run function urcl:run/arg/get/memory with storage urcl:temp

scoreboard players operation type= urcl.runtime = out_type= urcl.runtime
execute store result storage urcl:temp mem_val int 1 run scoreboard players get out_val= urcl.runtime
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/_ with storage urcl:temp
function urcl:run/arg/set/memory with storage urcl:temp