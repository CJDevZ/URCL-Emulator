execute unless data storage urcl:temp copy_args[] run return 1
execute if data storage urcl:temp copy_args[-1][] run scoreboard players add &instruction urcl.temp 1
data remove storage urcl:temp copy_args[-1][-1]
execute if data storage urcl:temp copy_args[-1][] run scoreboard players add &instruction urcl.temp 1
data remove storage urcl:temp copy_args[-1]
function urcl:compile/tokenize/labels_qwq/jump_op_loop