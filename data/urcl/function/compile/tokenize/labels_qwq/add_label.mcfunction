data modify storage urcl:temp defines append value {value:[I;0,0]}
data modify storage urcl:temp defines[-1].name set string storage urcl:temp line 0 -1
execute store result storage urcl:temp defines[-1].value[1] int 1 run scoreboard players get &instruction urcl.temp