data remove storage urcl:temp lines[0]
execute store result storage urcl:temp line int 1 run scoreboard players add &line urcl.temp 1
return run function urcl:compile/tokenize/line/loop