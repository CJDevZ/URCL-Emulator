# 4th Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[3]
execute store result storage uuid:temp 7 int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
execute store result storage uuid:temp 6 int 1 run scoreboard players operation @s uuid /= 65536 __int__

# 3rd Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[2]
execute store result storage uuid:temp 5 int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
execute store result storage uuid:temp 4 int 1 run scoreboard players operation @s uuid /= 65536 __int__

# 2nd Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[1]
execute store result storage uuid:temp 3 int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
execute store result storage uuid:temp 2 int 1 run scoreboard players operation @s uuid /= 65536 __int__

# 1st Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[0]
execute store result storage uuid:temp 1 int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
execute store result storage uuid:temp 0 int 1 run scoreboard players operation @s uuid /= 65536 __int__

# Map to Hex
function uuid:map with storage uuid:temp

# Store Result
function uuid:result with storage uuid:temp