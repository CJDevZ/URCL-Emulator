# ARG = "R100", ARG OFFSET = R"100", ARG_TYPE = "R"100

# Arg Type
data modify storage urcl:temp compiled[-1] append value 0

# Arg Value
$execute store result score #works urcl.temp run data modify storage urcl:temp compiled[-1] from storage urcl:temp $(arg)
execute if score #works urcl.temp matches 0 run data modify storage urcl:temp compiled[-1] append value 0