$execute store result score type= urcl.runtime run data get storage urcl:runtime workspace.memory[$(type_idx)]
$execute store result score val= urcl.runtime \
store result storage urcl:temp mem_val int 1 run data get storage urcl:runtime workspace.memory[$(val_idx)]