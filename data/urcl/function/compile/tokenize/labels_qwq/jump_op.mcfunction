$execute unless data storage urcl:rom ops[{name:"$(line)"}] run return 1
scoreboard players add &instruction urcl.temp 1
$data modify storage urcl:temp copy_args set from storage urcl:rom ops[{name:"$(line)"}].args
function urcl:compile/tokenize/labels_qwq/jump_op_loop