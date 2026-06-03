$execute store result score port= urcl.runtime run data get storage urcl:runtime workspace.memory[$(pc0)]
$data modify storage urcl:temp pc1 set from storage urcl:runtime workspace.memory[$(pc1)]