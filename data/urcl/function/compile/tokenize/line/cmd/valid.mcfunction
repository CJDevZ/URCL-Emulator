# ARG = "R100", ARG OFFSET = R"100", ARG_TYPE = "R"100

# Valid Check
execute unless data storage urcl:temp {allowed_types:[1]} run return run function urcl:compile/tokenize/line/err/invalid_args/error_arg

# Arg Type
$execute store result score $arg_type urcl.temp run data get storage urcl:rom arg_types.$(arg_type)
execute if data storage urcl:temp operator.args[0][1] if score $arg_type urcl.temp matches 1 run scoreboard players operation $arg_mask urcl.temp += $arg_bit urcl.temp

# Arg Value
$data modify storage urcl:temp compiled[-1] append value $(arg_offset)