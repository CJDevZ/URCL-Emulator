execute unless data storage urcl:temp copy_instruction[] run return 1

data remove storage urcl:temp copy_args[0][0]
execute if data storage urcl:temp copy_args[0][] run data modify storage urcl:temp compiled[-1] append from storage urcl:temp copy_instruction[0]
data modify storage urcl:temp compiled[-1] append from storage urcl:temp copy_instruction[1]

data remove storage urcl:temp copy_instruction[1]
data remove storage urcl:temp copy_instruction[0]
data remove storage urcl:temp copy_args[0]
function urcl:compile/tokenize/line/loop_fix