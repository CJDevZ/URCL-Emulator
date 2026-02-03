execute unless score @s urcl.runtime.curLine < #line urcl.runtime run return run scoreboard players reset @s urcl.runtime.alive

execute store result storage urcl:temp curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/tick/loop with storage urcl:temp

execute unless score @s urcl.runtime.delay matches 1.. if score @s urcl.runtime.alive matches 1 run function urcl:run/tick/run_till_loop