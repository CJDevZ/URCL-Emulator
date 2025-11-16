execute unless data storage urcl:temp lines[] run return 1

# Remove Whitespace
data modify storage strlib:in string set from storage urcl:temp lines[0]
data modify storage strlib:in split set value " "
function strlib:api/unsafe_split
data modify storage strlib:in array set from storage strlib:out split
function strlib:api/str_array_trim_blank
data modify storage urcl:temp line set from storage strlib:out array[0]
execute unless data storage strlib:out array[] run data modify storage urcl:temp line set value ""
# Get Length
execute store result score #line urcl.temp run data get storage urcl:temp line
# Check if Label
data modify storage urcl:temp last_char set string storage urcl:temp line -1
# Check if Comment
data modify storage urcl:temp first_char set string storage urcl:temp line 0 1
execute if score #line urcl.temp matches 2.. if data storage urcl:temp {last_char:":"} unless data storage urcl:temp {first_char:"#"} unless data storage urcl:temp {first_char:";"} run function urcl:compile/tokenize/labels_qwq/add_label
execute if score #line urcl.temp matches 1.. unless data storage urcl:temp {last_char:":"} unless data storage urcl:temp {first_char:"#"} unless data storage urcl:temp {first_char:";"} run function urcl:compile/tokenize/labels_qwq/jump_op with storage urcl:temp
execute if score #line urcl.temp matches 7 if data storage urcl:temp {line:"@DEFINE"} run function urcl:compile/tokenize/labels_qwq/add_define

data remove storage urcl:temp lines[0]
function urcl:compile/tokenize/labels_qwq/line