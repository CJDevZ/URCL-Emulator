data modify storage urcl:temp compiled append value [I;]
$data modify storage urcl:temp operator set from storage urcl:rom ops[{name:"$(op)"}]
data modify storage urcl:temp compiled[-1] append from storage urcl:temp operator.id
execute unless data storage urcl:temp operator.args run return fail
execute unless data storage urcl:temp operator.args[] run return 0
return run execute if data storage urcl:temp operator.args[]