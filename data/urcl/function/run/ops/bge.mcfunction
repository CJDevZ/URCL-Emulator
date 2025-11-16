# BGE
function urcl:run/arg/load_addr/_
data modify storage urcl:temp out_type set from storage urcl:temp mem_type
data modify storage urcl:temp out_val set from storage urcl:temp mem_val

function urcl:run/arg/load_addr/_
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp

function urcl:run/arg/load_addr/_
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
execute if score #1 urcl.math matches ..-1 if score #2 urcl.math matches 0.. run return fail
execute if score #1 urcl.math matches ..-1 run scoreboard players add #1 urcl.math 2147483647
execute if score #2 urcl.math matches ..-1 run scoreboard players add #2 urcl.math 2147483647
execute unless score #1 urcl.math >= #2 urcl.math run return fail

data modify storage urcl:temp mem_type set from storage urcl:temp out_type
data modify storage urcl:temp mem_val set from storage urcl:temp out_val
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
execute store result score @s urcl.runtime.curLine run scoreboard players remove #1 urcl.math 1