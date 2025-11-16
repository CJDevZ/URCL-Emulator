advancement revoke @s only urcl:compile_book

execute unless items entity @s weapon.offhand writable_book[custom_data~{code_book:1b}] run return run title @s actionbar {text:"Select a Code Book in Offhand",color:"red"}
execute unless items entity @s weapon.offhand *[writable_book_content~{pages:{size:{min:1}}}] run return run title @s actionbar {text:"Code something first",color:"red"}
execute if items entity @s weapon.mainhand * run return run title @s actionbar {text:"Clear your Mainhand",color:"red"}

data modify storage urcl:temp compiled set value []
scoreboard players set ?success_compile urcl.temp 1
data modify storage urcl:temp defines set value []
data modify storage urcl:temp pages set from entity @s equipment.offhand.components."minecraft:writable_book_content".pages

execute store result score #page urcl.temp if data storage urcl:temp pages[]

scoreboard players set &page urcl.temp 0
scoreboard players set &instruction urcl.temp 0
data modify storage urcl:temp precompile set value []
data modify storage urcl:temp copy_pages set from storage urcl:temp pages
function urcl:compile/tokenize/labels_qwq/_

scoreboard players set &page urcl.temp 0
data modify storage urcl:temp copy_pages set from storage urcl:temp pages
function urcl:compile/tokenize/loop with storage urcl:temp

execute unless score ?success_compile urcl.temp matches 1 run return run tellraw @s {text:"Failed to Compile",color:"red"}

data modify storage urcl:temp compiled append value [I;0]
data modify storage urcl:temp compiled[-1][0] set from storage urcl:rom ops[{name:"HLT"}].id
item replace entity @s weapon.mainhand with book[item_name='Compiled Code',rarity=rare]
item modify entity @s weapon.mainhand urcl:copy_compiled
tellraw @s {text:"Compiled Code",color:"green"}