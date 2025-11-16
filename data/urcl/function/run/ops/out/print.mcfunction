# PRINT
execute if entity @s[type=player] run return run tellraw @s [{"text":"> ","color":"gray"},{"score":{"name":"value=","objective":"urcl.runtime"}}]
execute store result storage urcl:temp print int 1 run scoreboard players get value= urcl.runtime
data modify entity 94cff2ce-2f43-4dc3-beb3-c0fddbe3609b text.extra append string storage urcl:temp print
data modify entity 94cff2ce-2f43-4dc3-beb3-c0fddbe3609b text.extra append value "\n"