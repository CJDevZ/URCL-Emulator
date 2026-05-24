# Defined Value
$execute store result score $arg_type urcl.temp run data get storage urcl:temp defines[{name:"$(arg)"}].value[0]
scoreboard players operation $op urcl.temp += $arg_type urcl.temp
$data modify storage urcl:temp compiled[-1] append from storage urcl:temp defines[{name:"$(arg)"}].value[1]