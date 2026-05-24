execute unless score value= urcl.runtime matches 0..63 run return run scoreboard players reset @s urcl.runtime.port.xy
scoreboard players operation @s urcl.runtime.port.xy /= 64 __int__
scoreboard players operation @s urcl.runtime.port.xy *= 64 __int__
scoreboard players operation @s urcl.runtime.port.xy += value= urcl.runtime