scoreboard players operation @s urcl.runtime.port.y = value= urcl.runtime
execute unless score value= urcl.runtime matches 0..71 run return run scoreboard players reset @s urcl.runtime.port.xy
execute unless score @s urcl.runtime.port.xy matches -2147483648..2147483647 run return run function urcl:run/ops/out/rgb/set_y0
scoreboard players operation @s urcl.runtime.port.xy %= 128 __int__
scoreboard players operation value= urcl.runtime *= 128 __int__
scoreboard players operation @s urcl.runtime.port.xy += value= urcl.runtime