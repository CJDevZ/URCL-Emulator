advancement revoke @s only urcl:dupe_book
execute unless items entity @s weapon.offhand writable_book[custom_data~{code_book:1b}] run return run title @s actionbar {"text":"Select Code Book in Offhand","color":"red"}
execute if items entity @s weapon.mainhand * run return run title @s actionbar {"text":"Clear your Mainhand","color":"red"}
item replace entity @s weapon.mainhand from entity @s weapon.offhand