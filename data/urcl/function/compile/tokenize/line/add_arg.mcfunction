execute unless data storage strlib:out array[] run return 1

data modify storage urcl:temp arg set from storage strlib:out array[0]
data modify storage urcl:temp arg_offset set string storage urcl:temp arg 1
data modify storage urcl:temp arg_type set string storage urcl:temp arg 0 1
function urcl:compile/tokenize/line/cmd/add_arg with storage urcl:temp

data remove storage strlib:out array[0]
data remove storage urcl:temp copy_args[0]
function urcl:compile/tokenize/line/add_arg