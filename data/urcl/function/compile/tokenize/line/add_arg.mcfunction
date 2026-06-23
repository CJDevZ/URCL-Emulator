execute unless data storage strlib:out array[] run return 1

data modify storage urcl:temp arg set from storage strlib:out array[0]
data modify storage urcl:temp arg_offset set string storage urcl:temp arg 1
data modify storage urcl:temp arg_type set string storage urcl:temp arg 0 1
data modify storage urcl:temp allowed_types set from storage urcl:temp operator.args[0]
function urcl:compile/tokenize/line/cmd/add_arg with storage urcl:temp

execute if data storage urcl:temp operator.args[0][1] run scoreboard players operation $arg_bit urcl.temp /= 2 __int__

data remove storage strlib:out array[0]
data remove storage urcl:temp operator.args[0]
function urcl:compile/tokenize/line/add_arg