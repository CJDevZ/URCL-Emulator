# ARG = "R100", ARG OFFSET = R"100", ARG_TYPE = "R"100

# Arg Type
$data modify storage urcl:temp compiled[-1] append from storage urcl:rom arg_types.$(arg_type)
execute unless score ?valid_arg urcl.temp matches 1 run data modify storage urcl:temp compiled[-1] append value 0

# Arg Value
$data modify storage urcl:temp compiled[-1] append value $(arg_offset)