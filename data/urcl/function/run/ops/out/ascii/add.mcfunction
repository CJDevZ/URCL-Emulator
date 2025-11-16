data modify storage urcl:temp ascii set value 0
$execute store success score success? urcl.temp run data modify storage urcl:temp ascii set from storage urcl:runtime workspace.memory[$(pointer)]
execute unless score success? urcl.temp matches 1 run return 1
execute store result score ascii urcl.temp store result score ascii1 urcl.temp run data get storage urcl:temp ascii
# Convert to Ascii
execute store result storage urcl:temp ascii int 1 run scoreboard players operation ascii urcl.temp %= 65536 __int__
function urcl:run/ops/out/ascii/hex with storage urcl:temp
data modify storage urcl:temp ascii1 set from storage urcl:temp ascii
execute store result storage urcl:temp ascii int 1 run scoreboard players operation ascii1 urcl.temp /= 65536 __int__
function urcl:run/ops/out/ascii/hex with storage urcl:temp
function urcl:run/ops/out/ascii/macro with storage urcl:temp

execute store result storage urcl:temp pointer int 1 run scoreboard players add value= urcl.runtime 1
function urcl:run/ops/out/ascii/add with storage urcl:temp