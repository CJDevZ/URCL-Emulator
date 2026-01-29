# DEC
execute store result score out urcl.runtime run function urcl:run/arg/load_addr/direct

function urcl:run/arg/load_addr/_
<<<<<<< HEAD
execute store result score val= urcl.runtime run function urcl:run/arg/get/_ with storage urcl:temp

scoreboard players remove val= urcl.runtime 1
=======
execute store result score #1 urcl.math run function urcl:run/arg/get/_ with storage urcl:temp

execute store result score val= urcl.runtime run scoreboard players remove #1 urcl.math 1
>>>>>>> 0b9b55b165dc3b3bfe5892223dea2e1b0b45533b
execute store result storage urcl:temp mem_val int 1 run scoreboard players get out urcl.runtime
function urcl:run/arg/set/register with storage urcl:temp