advancement revoke @s only urcl:get_book
execute if items entity @s weapon.mainhand * run return run title @s actionbar {text:"Clear your Mainhand",color:"red"}
item replace entity @s weapon.mainhand with writable_book[item_name='Code',rarity=uncommon,custom_data={code_book:1b}]