# ARG = "R100", ARG OFFSET = R"100", ARG_TYPE = "R"100

# Valid Check
execute unless data storage urcl:temp {allowed_types:[0]} run return run function urcl:compile/tokenize/line/err/invalid_args/error_arg

# Arg Value
$execute store success score #works urcl.temp run data modify storage urcl:temp compiled[-1] append value $(arg)
execute if score #works urcl.temp matches 0 run data modify storage urcl:temp compiled[-1] append value 0