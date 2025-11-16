# 4th Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[3]

execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
function uuid:map with storage uuid:temp
data modify storage uuid:temp 7 set from storage uuid:temp value
execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid /= 65536 __int__
function uuid:map with storage uuid:temp
data modify storage uuid:temp 6 set from storage uuid:temp value

# 3rd Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[2]

execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
function uuid:map with storage uuid:temp
data modify storage uuid:temp 5 set from storage uuid:temp value
execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid /= 65536 __int__
function uuid:map with storage uuid:temp
data modify storage uuid:temp 4 set from storage uuid:temp value

# 2nd Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[1]

execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
function uuid:map with storage uuid:temp
data modify storage uuid:temp 3 set from storage uuid:temp value
execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid /= 65536 __int__
function uuid:map with storage uuid:temp
data modify storage uuid:temp 2 set from storage uuid:temp value

# 1st Part
execute store result score @s uuid store result score @s uuid.0 run data get entity @s UUID[0]

execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid.0 %= 65536 __int__
function uuid:map with storage uuid:temp
data modify storage uuid:temp 1 set from storage uuid:temp value
execute store result storage uuid:temp value int 1 run scoreboard players operation @s uuid /= 65536 __int__
function uuid:map with storage uuid:temp

# Store Result
function uuid:result with storage uuid:temp