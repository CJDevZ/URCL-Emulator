data remove storage urcl:temp err
function urcl:compile/tokenize/line/err/invalid_opcode/test
function urcl:compile/tokenize/line/err/invalid_argcount/test
function urcl:compile/tokenize/line/err/invalid_args/test with storage urcl:temp
execute unless data storage urcl:temp err[] run return fail

scoreboard players operation &pagen urcl.temp = &page urcl.temp
scoreboard players add &pagen urcl.temp 1
scoreboard players operation &linen urcl.temp = &line urcl.temp
scoreboard players add &linen urcl.temp 1
tellraw @s [{color:"red",text:"Error on Page "},{score:{name:"&pagen",objective:"urcl.temp"}}," Line ",{score:{name:"&linen",objective:"urcl.temp"}},":"]

tellraw @s [{text:" → ",color:"red"},{nbt:"err[].message",storage:"urcl:temp",separator:"\n → ",interpret:true}]

return 1