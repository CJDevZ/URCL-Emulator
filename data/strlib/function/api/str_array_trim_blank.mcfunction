execute store result score #left strlib if data storage strlib:in array[]
execute unless score #left strlib matches 1.. run return fail
data modify storage strlib:out array set value []
data modify storage strlib:temp array set from storage strlib:in array
function strlib:priv/str_array/trim_blank