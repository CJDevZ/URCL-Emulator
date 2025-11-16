execute unless data storage urcl:temp lines[] run return 1

# Check if Comment/Define
data modify storage urcl:temp first_char set string storage urcl:temp lines[0] 0 1
execute if data storage urcl:temp {first_char:"#"} run return run function urcl:compile/tokenize/line/special_lines/add_nop
execute if data storage urcl:temp {first_char:";"} run return run function urcl:compile/tokenize/line/special_lines/add_nop
execute if data storage urcl:temp {first_char:"@"} run return run function urcl:compile/tokenize/line/special_lines/add_nop

# Check if Label
data modify storage urcl:temp last_char set string storage urcl:temp lines[0] -1
execute if data storage urcl:temp {last_char:":"} run return run function urcl:compile/tokenize/line/special_lines/add_nop

# Check if Empty
data modify storage strlib:in string set value ""
execute store success score !empty urcl.temp run data modify storage strlib:in string set from storage urcl:temp lines[0]
execute if score !empty urcl.temp matches 0 run return run function urcl:compile/tokenize/line/special_lines/add_nop


# Split Line with " "
data modify storage strlib:in split set value " "
function strlib:api/unsafe_split
# Remove Blanks ""
data modify storage strlib:in array set from storage strlib:out split
function strlib:api/str_array_trim_blank
# Get OP Code
data modify storage urcl:temp op set from storage strlib:out array[0]
data remove storage strlib:out array[0]
# Get Arg Count
execute store result score #op urcl.temp if data storage strlib:out array[]

###
execute store success score ?success_op urcl.temp store result score #requiredop urcl.temp run function urcl:compile/tokenize/line/check_op with storage urcl:temp
# Add Args
function urcl:compile/tokenize/line/add_arg

# Check Errors
execute if function urcl:compile/tokenize/line/err/_ run scoreboard players set ?success_compile urcl.temp 0

# Fix Unnecessary Type Data
data modify storage urcl:temp copy_instruction set from storage urcl:temp compiled[-1]
data modify storage urcl:temp compiled[-1] set value [I;]
data modify storage urcl:temp compiled[-1] append from storage urcl:temp copy_instruction[0]
data remove storage urcl:temp copy_instruction[0]
function urcl:compile/tokenize/line/get_op_args with storage urcl:temp
function urcl:compile/tokenize/line/loop_fix

#$data modify storage urcl:temp char set string storage urcl:temp raw $(char1) $(char2)
#execute store success score =success urcl.temp run function urcl:compile/tokenize/page/allowed_char with storage urcl:temp
#execute unless score =success urcl.temp matches 1 run tellraw @s {"text":"[A-Z0-9 ] only","color":"red"}
#execute unless score =success urcl.temp matches 1 run return fail
# Here it adds the Characters to the Precompile part, aka tokens
#data modify storage urcl:temp precompile append from storage urcl:temp char

data remove storage urcl:temp lines[0]
execute store result storage urcl:temp line int 1 run scoreboard players add &line urcl.temp 1
return run function urcl:compile/tokenize/line/loop