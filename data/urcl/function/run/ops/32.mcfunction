# PSH
function urcl:run/arg/load_addr/_
execute store result storage urcl:temp value int 1 run function urcl:run/arg/get/_ with storage urcl:temp
function urcl:run/ops/stack/push