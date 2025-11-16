# CPY
function urcl:run/arg/load_addr/_
data modify storage urcl:temp out_type set from storage urcl:temp mem_type
data modify storage urcl:temp out_val set from storage urcl:temp mem_val


function urcl:run/arg/load_addr/_
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/_ with storage urcl:temp
execute store result score #1 urcl.math run function urcl:run/arg/get/memory with storage urcl:temp

data modify storage urcl:temp mem_type set from storage urcl:temp out_type
data modify storage urcl:temp mem_val set from storage urcl:temp out_val
execute store result storage urcl:temp mem_val int 1 run function urcl:run/arg/get/_ with storage urcl:temp
function urcl:run/arg/set/memory with storage urcl:temp