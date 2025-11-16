data modify storage strlib:temp match set from storage strlib:temp array[-1]
execute store success score match? strlib if data storage strlib:temp {match:""}
execute unless score match? strlib matches 1 run data modify storage strlib:out array prepend from storage strlib:temp array[-1]
data remove storage strlib:temp array[-1]
scoreboard players remove #left strlib 1
execute if score #left strlib matches 1.. run return run function strlib:priv/str_array/trim_blank