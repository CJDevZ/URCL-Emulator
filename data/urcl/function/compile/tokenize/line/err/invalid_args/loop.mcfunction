execute unless data storage urcl:temp copy_instructions[] run return 1

data modify storage urcl:temp arg_type set from storage urcl:temp copy_instructions[0]
data modify storage urcl:temp args_allowed set from storage urcl:temp copy_args[0]
execute unless function urcl:compile/tokenize/line/err/invalid_args/loop_check run return run data modify storage urcl:temp err append value {error:"args",message:"Invalid Args"}

#tellraw @s {nbt:"copy_instructions",storage:"urcl:temp"}
data remove storage urcl:temp copy_instructions[1]
data remove storage urcl:temp copy_instructions[0]
data remove storage urcl:temp copy_args[0]
return run function urcl:compile/tokenize/line/err/invalid_args/loop