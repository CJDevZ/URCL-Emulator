execute store result storage urcl:temp R int 1 run scoreboard players get @s urcl.runtime.port.r
execute store result storage urcl:temp G int 1 run scoreboard players get @s urcl.runtime.port.g
execute store result storage urcl:temp B int 1 run scoreboard players get @s urcl.runtime.port.b
function urcl:display/set_pixel/set_color/_ with storage urcl:temp