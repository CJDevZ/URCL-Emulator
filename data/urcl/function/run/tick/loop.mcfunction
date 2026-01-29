#tellraw @a {"text":"Executing opcode: ","color":"yellow","extra":[{"score":{"name":"op=","objective":"urcl.runtime"},"color":"aqua"}]}
$data modify storage urcl:runtime op_code set from storage urcl:runtime workspace.memory[$(curLine)]
function urcl:run/tick/run_instruction with storage urcl:runtime
