# ARG = "R100", ARG OFFSET = R"100", ARG_TYPE = "R"100

# Arg Type
$data modify storage urcl:temp defines[-1].value[0] set from storage urcl:rom arg_types.$(arg_type)

# Arg Value
$data modify storage urcl:temp defines[-1].value[1] set value $(arg_offset)