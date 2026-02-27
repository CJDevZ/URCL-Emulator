# IN
execute store result storage urcl:temp out_val int 1 run function urcl:run/arg/load_addr/direct
execute store result score port= urcl.runtime run function urcl:run/arg/load_addr/direct

scoreboard players set out= urcl.runtime 0
execute if score port= urcl.runtime matches 1 store result score out= urcl.runtime run random value 0..2147483646
execute if score port= urcl.runtime matches 2 run scoreboard players operation out= urcl.runtime = #port.dpad urcl.runtime

function urcl:run/arg/set/register with storage urcl:temp