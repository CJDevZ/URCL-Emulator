gamemode adventure @a[predicate=urcl:sneak,tag=urcl.player]
tag @a[predicate=urcl:sneak,tag=urcl.player] remove urcl.player
execute as @e[type=item] if items entity @s container.0 writable_book[custom_data~{code_book:1b}] unless data entity @s Item.components."minecraft:writable_book_content" run kill @s

scoreboard players remove @a[scores={urcl.runtime.delay=1..}] urcl.runtime.delay 1
execute as b4c2ef2d-f22f-40b1-9b81-452342af735c if score @s urcl.runtime.delay matches 1.. run scoreboard players remove @s urcl.runtime.delay 1

scoreboard players set #port.dpad urcl.runtime 0
execute if entity @a[tag=urcl.player,predicate=urcl:forward] run scoreboard players add #port.dpad urcl.runtime 1
execute if entity @a[tag=urcl.player,predicate=urcl:right] run scoreboard players add #port.dpad urcl.runtime 2
execute if entity @a[tag=urcl.player,predicate=urcl:backward] run scoreboard players add #port.dpad urcl.runtime 4
execute if entity @a[tag=urcl.player,predicate=urcl:left] run scoreboard players add #port.dpad urcl.runtime 8
execute if entity @a[tag=urcl.player,predicate=urcl:jump] run scoreboard players add #port.dpad urcl.runtime 16

data modify entity b4c2ef2d-f22f-40b1-9b81-452342af735c text.extra set from storage urcl:temp frame_buffer
data modify storage urcl:temp frame_buffer set from entity b4c2ef2d-f22f-40b1-9b81-452342af735c text.extra
execute as b4c2ef2d-f22f-40b1-9b81-452342af735c if score @s urcl.runtime.alive matches 1.. unless score @s urcl.runtime.delay matches 1.. run function urcl:run/tick/_
data modify entity b4c2ef2d-f22f-40b1-9b81-452342af735c text.extra set from storage urcl:temp frame_buffer