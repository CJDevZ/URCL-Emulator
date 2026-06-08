execute unless score @s urcl.runtime.port.x matches 0..63 run return 1

scoreboard players operation @s urcl.runtime.port.xy = @s urcl.runtime.port.y
scoreboard players operation @s urcl.runtime.port.xy *= 64 __int__
scoreboard players operation @s urcl.runtime.port.xy += @s urcl.runtime.port.x