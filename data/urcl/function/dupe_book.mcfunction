advancement revoke @s only urcl:dupe_book
execute unless items entity @s weapon.offhand #urcl:books[custom_data~{code_book:1b}] run return run title @s actionbar {text:"Select Code Book in Offhand",color:"red"}
execute if items entity @s weapon.mainhand * run return run title @s actionbar {text:"Clear your Mainhand",color:"red"}
summon item_display ~ ~ ~ {UUID:[I;-826626250,859523891,-1252522664,759937356]}
item replace entity cebaaf36-333b-4b33-b558-05582d4bb94c contents from entity @s weapon.offhand
data modify entity cebaaf36-333b-4b33-b558-05582d4bb94c item.id set value writable_book
data modify entity cebaaf36-333b-4b33-b558-05582d4bb94c item.components.minecraft:writable_book_content merge from entity cebaaf36-333b-4b33-b558-05582d4bb94c item.components.minecraft:written_book_content
data remove entity cebaaf36-333b-4b33-b558-05582d4bb94c item.components.minecraft:written_book_content
item replace entity @s weapon.mainhand from entity cebaaf36-333b-4b33-b558-05582d4bb94c contents
kill cebaaf36-333b-4b33-b558-05582d4bb94c