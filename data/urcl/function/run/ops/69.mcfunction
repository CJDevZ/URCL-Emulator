# IN
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc1 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch/in with storage urcl:temp

scoreboard players reset out= urcl.runtime
execute if score port= urcl.runtime matches 1 store result score out= urcl.runtime run random value 0..2147483646
execute if score port= urcl.runtime matches 2 run scoreboard players operation out= urcl.runtime = #port.dpad urcl.runtime

execute if score out= urcl.runtime matches -2147483648..2147483647 run function urcl:run/arg/set/register/pc0 with storage urcl:temp
execute store result storage urcl:runtime curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1