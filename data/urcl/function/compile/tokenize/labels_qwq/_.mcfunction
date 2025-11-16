execute unless data storage urcl:temp copy_pages[] run return 1

# Splitting Lines
data modify storage strlib:in string set from storage urcl:temp copy_pages[0].raw
data modify storage strlib:in split set value "\n"
function strlib:api/unsafe_split
data modify storage urcl:temp lines set from storage strlib:out split
execute store result score #line urcl.temp if data storage strlib:out split[]

# Looping through split lines
scoreboard players set &line urcl.temp 0
function urcl:compile/tokenize/labels_qwq/line

data remove storage urcl:temp copy_pages[0]
scoreboard players add &page urcl.temp 1
function urcl:compile/tokenize/labels_qwq/_