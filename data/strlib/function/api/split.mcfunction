execute store result score #left strlib store result score &char strlib store result storage strlib:temp left int 1 run data get storage strlib:in string
execute unless score #left strlib matches 1.. run return run data modify storage strlib:out split set value [""]
execute store success score ?string strlib run data modify storage strlib:temp string set from storage strlib:in string
execute if score ?string strlib matches 0 run return fail
data modify storage strlib:temp string2 set from storage strlib:in string
data modify storage strlib:out split set value []
execute store result storage strlib:temp from int 1 run scoreboard players remove &char strlib 1
execute store result storage strlib:temp left1 int 1 run scoreboard players remove #left1 strlib 1
function strlib:priv/fast_split/_