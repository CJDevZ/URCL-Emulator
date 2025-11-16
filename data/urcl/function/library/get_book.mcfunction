advancement revoke @s only urcl:library_give_book

execute if items entity @s weapon.mainhand * as @e[type=interaction,tag=urcl.library_get_book] run data remove entity @s interaction
execute if items entity @s weapon.mainhand * run return run title @s actionbar {"text":"Clear your Hand","color":"red"}

tag @s add urcl.library_give_book
execute as @e[type=interaction,tag=urcl.library_give_book,predicate=urcl:has_target] at @s positioned ~ ~.125 ~ run item replace entity @p[tag=urcl.library_give_book] weapon.mainhand from entity @n[type=item_display,distance=..0.125] container.0
execute as @e[type=interaction,tag=urcl.library_give_book,predicate=urcl:has_target] run data remove entity @s interaction

tag @s remove urcl.library_give_book