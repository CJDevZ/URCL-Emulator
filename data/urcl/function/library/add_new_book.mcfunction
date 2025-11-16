execute unless items entity @s weapon.mainhand writable_book[custom_data~{code_book:1b},writable_book_content~{pages:{size:{min:1}}}] run return run title @s actionbar {"text":"Select a Code Book","color":"red"}
$data modify storage urcl:library books append value {pages:[],author:"$(author)",name:"$(name)"}
data modify storage urcl:library books[-1].pages set from entity @s SelectedItem.components."minecraft:writable_book_content".pages
execute store result storage urcl:temp idx int 1 store result score #10 urcl.math store result score #11 urcl.math if data storage urcl:library books[]

data modify storage urcl:temp library set from storage urcl:library books[-1]

execute store result score #10 urcl.temp if data storage urcl:library books[]
execute positioned 0 0 0 summon item_display run function urcl:library/spawn_book/1 with storage urcl:temp library