data modify storage urcl:temp compiled append value [I;]
$data modify storage urcl:temp compiled[-1] append from storage urcl:rom ops[{name:"$(op)"}].id
$execute unless data storage urcl:rom ops[{name:"$(op)"}].args run return fail
$execute unless data storage urcl:rom ops[{name:"$(op)"}].args[] run return 0
$return run execute if data storage urcl:rom ops[{name:"$(op)"}].args[]