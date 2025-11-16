# PRINT ASCII
# Input: Pointer in Memory
data remove storage urcl:runtime print
execute store result storage urcl:temp pointer int 1 run scoreboard players get value= urcl.runtime
function urcl:run/ops/out/ascii/add with storage urcl:temp
execute if entity @s[type=player] run return run tellraw @s [{"text":"> ","color":"gray"},{nbt:"print[]",storage:"urcl:runtime",separator:""}]
data modify entity 94cff2ce-2f43-4dc3-beb3-c0fddbe3609b text.extra append value {nbt:"print[]",storage:"urcl:runtime",separator:""}