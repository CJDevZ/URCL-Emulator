data modify storage strlib:temp char set string storage strlib:temp string -1
data modify storage strlib:temp string set string storage strlib:temp string 0 -1

data modify storage strlib:temp match set from storage strlib:temp char
execute store success score !success strlib store success score ?exclude strlib run data modify storage strlib:temp match set from storage strlib:in split

scoreboard players add ?exclude strlib 1
execute store result storage strlib:temp exclude int 1 run scoreboard players operation ?exclude strlib %= 2 __int__
execute if score #left strlib matches 1 run return run function strlib:priv/fast_split/end with storage strlib:temp

execute if score !success strlib matches 0 run function strlib:priv/fast_split/_concat with storage strlib:temp
execute if score !success strlib matches 1 run scoreboard players remove &char strlib 1
execute if score !success strlib matches 0 store result storage strlib:temp from int 1 run scoreboard players remove &char strlib 1


execute store result storage strlib:temp left int 1 store result score #left1 strlib run scoreboard players remove #left strlib 1
execute store result storage strlib:temp left1 int 1 run scoreboard players remove #left1 strlib 1
return run function strlib:priv/fast_split/_