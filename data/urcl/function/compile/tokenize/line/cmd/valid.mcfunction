# ARG = "R100", ARG OFFSET = R"100", ARG_TYPE = "R"100

# Arg Type
$execute store result score $arg_type urcl.temp run data get storage urcl:rom arg_types.$(arg_type)
scoreboard players operation $op urcl.temp += $arg_type urcl.temp

# Arg Value
$data modify storage urcl:temp compiled[-1] append value $(arg_offset)