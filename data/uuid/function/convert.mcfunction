# 4th Part
execute store result score @s uuid store result storage uuid:temp 7 short 1 run data get storage uuid:in UUID[3]
execute store result storage uuid:temp 6 short 1 run scoreboard players operation @s uuid /= 65536 uuid

# 3rd Part
execute store result score @s uuid store result storage uuid:temp 5 short 1 run data get storage uuid:in UUID[2]
execute store result storage uuid:temp 4 short 1 run scoreboard players operation @s uuid /= 65536 uuid

# 2nd Part
execute store result score @s uuid store result storage uuid:temp 3 short 1 run data get storage uuid:in UUID[1]
execute store result storage uuid:temp 2 short 1 run scoreboard players operation @s uuid /= 65536 uuid

# 1st Part
execute store result score @s uuid store result storage uuid:temp 1 short 1 run data get storage uuid:in UUID[0]
execute store result storage uuid:temp 0 short 1 run scoreboard players operation @s uuid /= 65536 uuid

# Map to Hex
function uuid:map with storage uuid:temp

# Store Result
function uuid:result with storage uuid:temp