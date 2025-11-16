# OUT
execute store result score port= urcl.runtime run function urcl:run/arg/load_addr/direct

function urcl:run/arg/load_addr/_
execute store result storage urcl:temp value int 1 store result score value= urcl.runtime run function urcl:run/arg/get/_ with storage urcl:temp


execute if score port= urcl.runtime matches 1 run return run function urcl:run/ops/out/print
execute if score port= urcl.runtime matches 2 run return run scoreboard players operation @s urcl.runtime.delay = value= urcl.runtime


execute if score port= urcl.runtime matches 3 run return run scoreboard players operation @s urcl.runtime.port.x = value= urcl.runtime
execute if score port= urcl.runtime matches 4 run return run scoreboard players operation @s urcl.runtime.port.y = value= urcl.runtime
execute if score port= urcl.runtime matches 5 run return run scoreboard players operation @s urcl.runtime.port.r = value= urcl.runtime
execute if score port= urcl.runtime matches 6 run return run scoreboard players operation @s urcl.runtime.port.g = value= urcl.runtime
execute if score port= urcl.runtime matches 7 run return run scoreboard players operation @s urcl.runtime.port.b = value= urcl.runtime

execute if score port= urcl.runtime matches 8 run return run execute if entity @s[nbt={UUID:[I;-1262293203,-231784271,-1686026973,1118794588]}] run function urcl:run/ops/out/draw_screen

execute if score port= urcl.runtime matches 9 run return run function urcl:run/ops/out/print_ascii
execute if score port= urcl.runtime matches 10 run return run function urcl:run/ops/out/malloc with storage urcl:temp
execute if score port= urcl.runtime matches 11 run return run function urcl:run/ops/out/free with storage urcl:temp