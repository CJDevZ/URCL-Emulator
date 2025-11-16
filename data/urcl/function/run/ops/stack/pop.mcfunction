execute unless data storage urcl:runtime workspace.stack[] run return run function urcl:run/ops/stack/buffer_underflow
execute store result score #69 urcl.math run data get storage urcl:runtime workspace.stack[-1]
data remove storage urcl:runtime workspace.stack[-1]
return run scoreboard players get #69 urcl.math