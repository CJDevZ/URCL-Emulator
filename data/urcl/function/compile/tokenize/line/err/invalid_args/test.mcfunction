execute if data storage urcl:temp err[{error:"opcode"}] run return 1
execute if data storage urcl:temp err[{error:"arg_count"}] run return 1

data modify storage urcl:temp copy_instructions set from storage urcl:temp compiled[-1]
data remove storage urcl:temp copy_instructions[0]
$data modify storage urcl:temp copy_args set from storage urcl:rom ops[{name:"$(op)"}].args
function urcl:compile/tokenize/line/err/invalid_args/loop