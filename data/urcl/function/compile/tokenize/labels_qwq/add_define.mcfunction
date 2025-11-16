data modify storage urcl:temp defines append value {value:[I;0,0]}
data modify storage urcl:temp defines[-1].name set from storage strlib:out array[1]

data modify storage urcl:temp arg set value "0"
data modify storage urcl:temp arg set from storage strlib:out array[2]
data modify storage urcl:temp arg_offset set string storage urcl:temp arg 1
data modify storage urcl:temp arg_type set string storage urcl:temp arg 0 1
function urcl:compile/tokenize/labels_qwq/define/macro with storage urcl:temp