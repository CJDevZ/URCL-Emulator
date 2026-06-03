$data modify storage urcl:temp pc0 set from storage urcl:runtime workspace.memory[$(pc0)]
$execute store result score out= urcl.runtime run data get storage urcl:runtime workspace.memory[$(pc1)]