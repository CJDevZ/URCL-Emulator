# LSTR
function urcl:run/arg/load_addr/_
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
function urcl:run/arg/load_addr/_
execute store result score #2 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp
execute store result storage urcl:temp pointer int 1 run scoreboard players operation #1 urcl.math += #2 urcl.math

function urcl:run/arg/load_addr/_
execute store result storage urcl:temp value int 1 run function urcl:run/arg/get/_ with storage urcl:temp
function urcl:run/ops/ram/set with storage urcl:temp