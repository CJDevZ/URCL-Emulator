#tellraw @a {"text":"Executing opcode: ","color":"yellow","extra":[{"score":{"name":"op=","objective":"urcl.runtime"},"color":"aqua"}]}
$execute store result score $op_code urcl.runtime store result storage urcl:runtime op_code byte 1 run data get storage urcl:runtime workspace.memory[$(curLine)]
