# Defined Value
$execute store result score $arg_type urcl.temp run data get storage urcl:temp defines[{name:"$(arg)"}].value[0]
execute if data storage urcl:temp operator.args[0][1] run scoreboard players operation $arg_mask urcl.temp += $arg_type urcl.temp
$data modify storage urcl:temp compiled[-1] append from storage urcl:temp defines[{name:"$(arg)"}].value[1]