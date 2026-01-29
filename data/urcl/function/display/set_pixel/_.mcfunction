execute unless score @s urcl.runtime.port.x matches 0..64 run return fail
scoreboard players operation #y urcl.temp = @s urcl.runtime.port.y
scoreboard players operation #y urcl.temp *= 64 __int__
execute store result storage urcl:temp PIXEL int 1 run scoreboard players operation #y urcl.temp += @s urcl.runtime.port.x
execute unless score #y urcl.temp matches 0.. run return fail
function urcl:display/set_pixel/set_color with storage urcl:temp
