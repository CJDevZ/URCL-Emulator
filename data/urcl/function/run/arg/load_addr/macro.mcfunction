$execute store result score type= urcl.runtime run data get storage urcl:runtime workspace.memory[$(type_idx)]
<<<<<<< HEAD
$execute store result score val= urcl.runtime \
store result storage urcl:temp mem_val int 1 run data get storage urcl:runtime workspace.memory[$(val_idx)]
=======
$execute store result score val= urcl.runtime run data get storage urcl:runtime workspace.memory[$(val_idx)]
execute store result storage urcl:temp mem_val int 1 run scoreboard players get val= urcl.runtime
>>>>>>> 0b9b55b165dc3b3bfe5892223dea2e1b0b45533b
