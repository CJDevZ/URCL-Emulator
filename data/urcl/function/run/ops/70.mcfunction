# OUT
scoreboard players operation $op_code urcl.runtime *= 8388608 __int__
execute store result storage urcl:temp pc0 int 1 run scoreboard players add @s urcl.runtime.curLine 1
execute store result storage urcl:temp pc1 int 1 run scoreboard players add @s urcl.runtime.curLine 1
function urcl:run/arg/get/fetch/out with storage urcl:temp

execute store result storage urcl:temp value int 1 store result score value= urcl.runtime run function urcl:run/arg/get/pc1 with storage urcl:temp
execute store result storage urcl:runtime curLine int 1 run scoreboard players add @s urcl.runtime.curLine 1


execute if score port= urcl.runtime matches 1 run return run function urcl:run/ops/out/print
execute if score port= urcl.runtime matches 2 run return run scoreboard players operation @s urcl.runtime.delay = value= urcl.runtime


execute if score port= urcl.runtime matches 3 run return run function urcl:run/ops/out/rgb/set_x
execute if score port= urcl.runtime matches 4 run return run function urcl:run/ops/out/rgb/set_y
execute if score port= urcl.runtime matches 13 run return run scoreboard players operation @s urcl.runtime.port.xy = value= urcl.runtime

execute if score port= urcl.runtime matches 12 run return run scoreboard players operation @s urcl.runtime.port.rgb = value= urcl.runtime
execute if score port= urcl.runtime matches 5 run return run function urcl:run/ops/out/rgb/set_red
execute if score port= urcl.runtime matches 6 run return run function urcl:run/ops/out/rgb/set_green
execute if score port= urcl.runtime matches 7 run return run function urcl:run/ops/out/rgb/set_blue

execute if score port= urcl.runtime matches 8 run return run execute if score @s urcl.runtime.port.xy matches 0..2303 run function urcl:display/set_pixel/_

execute if score port= urcl.runtime matches 9 run return run function urcl:run/ops/out/print_ascii
execute if score port= urcl.runtime matches 10 run return run function urcl:run/ops/out/malloc with storage urcl:temp
execute if score port= urcl.runtime matches 11 run return run function urcl:run/ops/out/free with storage urcl:temp