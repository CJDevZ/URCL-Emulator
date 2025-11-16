$execute store result score type= urcl.runtime run data get storage urcl:runtime workspace.memory[$(type_idx)]
$execute store result score val= urcl.runtime run data get storage urcl:runtime workspace.memory[$(val_idx)]
function urcl:run/arg/translate