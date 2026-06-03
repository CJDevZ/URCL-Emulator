execute unless score @s urcl.runtime.curLine < #line urcl.runtime run return run scoreboard players reset @s urcl.runtime.alive

function urcl:run/tick/query_op with storage urcl:runtime
function urcl:run/tick/run_instruction with storage urcl:runtime

execute unless score @s urcl.runtime.delay matches 1.. if score @s urcl.runtime.alive matches 1 run function urcl:run/tick/run_till_loop