execute store result score #line urcl.runtime if data storage urcl:runtime workspace.memory[]
execute store result storage urcl:runtime curLine int 1 run scoreboard players get @s urcl.runtime.curLine
function urcl:run/tick/run_till_loop