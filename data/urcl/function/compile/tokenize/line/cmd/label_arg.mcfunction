# Defined Value
$execute store result score $arg_type urcl.temp run data get storage urcl:temp defines[{name:"$(arg)"}].value[0]

# Valid Check
execute if score $arg_type urcl.temp matches 0 unless data storage urcl:temp {allowed_types:[0]} run return run function urcl:compile/tokenize/line/err/invalid_args/error_arg
execute if score $arg_type urcl.temp matches 1 unless data storage urcl:temp {allowed_types:[1]} run return run function urcl:compile/tokenize/line/err/invalid_args/error_arg

# Arg Value
execute if data storage urcl:temp operator.args[0][1] if score $arg_type urcl.temp matches 1 run scoreboard players operation $arg_mask urcl.temp += $arg_bit urcl.temp
$data modify storage urcl:temp compiled[-1] append from storage urcl:temp defines[{name:"$(arg)"}].value[1]